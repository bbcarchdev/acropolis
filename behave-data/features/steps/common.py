import os
import json
from behave import given, when, then
from hamcrest import assert_that, equal_to, is_not, contains_string
from rdflib import ConjunctiveGraph, URIRef, Namespace
from rdflib.namespace import RDF, RDFS, FOAF, SKOS, VOID
from urllib import parse
import resutils
import config
import logging
import json

## GIVEN

@given("using live stack")
def step_impl_live_stack(context):
      context.host = config.LIVE

@given("Index is empty")
def step_impl_index_empty(context):
      resutils.clear_index(context)


@given('some ingested test data {file}')
def step_impl_ingest_data(context, file):
    if file in context.ingested:
        logging.info(file + " already ingested..\n")
        return
    else:
        with open("data/" + file, 'r') as f:
            context = resutils.ingest_data(context, f)
            context.ingested[file] = context.response
            json_response = json.loads(context.response.text)
            if (context.response.status_code is not 200) or ("Ingest completed" not in json_response["message"]):
                logging.info("Data ingestion failed..\n")
                assert(False)


@given('I search for query {query}')
def step_impl_query(context, query):
    context.requests_params['q'] = resutils.clean(query) if (config.NA not in query) else None

@given('I search for media {media}')
def step_impl_media(context, media):
    context.requests_params['media'] = resutils.clean(media) if (config.NA not in media) else None

@given('I search related media for audience list {audiences}')
def step_impl_audience_list(context, audiences):
    context.requests_params['for'] = resutils.clean(audiences).split(',')

@given('I search related media for audience {audience}')
def step_impl_audience(context, audience):
    context.requests_params['for'] = resutils.clean(audience)

@given('I accept content as {content}')
def step_impl_accept(context, content):
    # logging.info(json.dumps(requests_headers, indent=2)+"\n")
    context.requests_params['Accept'] = resutils.clean(content)

## WHEN

@when('I count the amount of relevant entities that are ingested')
def step_impl_count_relevant(context):
    report = resutils.count_objects_all(resutils.get_graph_for(context.response.content))
    context.relevant_dict = report

@when('I request {partition}')
def step_impl_partition(context, partition):

    if "root" in partition:
        partition = config.Partition.ROOT.value

    if 'Accept' in context.requests_headers:
        response = context.session.get(context.host + partition, params = context.requests_params, headers = {'Accept': context.requests_headers["Accept"] })
    else:
        response = context.session.get(context.host + partition, params = context.requests_params, headers = {'Accept': 'text/turtle'})
    # context.url = parse.unquote(response.url)
    context.url = response.url
    context.response = response
    # logging.info(response.text+"\n")
    logging.info("Calling URL => "+context.url+"\n")

## THEN

@then('the response contains a partition with label {text}')
def step_impl_item_contains_label(context, text):
    text = resutils.clean(text)
    logging.info("PARTITION: "+text)
    g = resutils.get_graph_for(context.response.content)
    labels = resutils.get_partition_labels(g, subject=context.url)
    assert_that(text in str(labels), equal_to(True))

@then('the response contains partitions: {partitions}')
def step_impl_item_contains_label(context, partitions):
    partitions = partitions.split(",")
    logging.info(str(partitions)+"\n")
    g = resutils.get_graph_for(context.response.content)
    labels = resutils.get_partition_labels(g, subject=context.url)
    logging.info(str(labels)+"\n")
    # assert_that(text in str(labels))
    for label in partitions:
        assert_that(label in labels, equal_to(True))

@then('the response contains an item with label {text}')
def step_impl_item_contains_label(context, text):
    text = resutils.clean(text)

    g = resutils.get_graph_for(context.response.content)
    labels = resutils.get_slot_labels(g, subject=context.url)
    assert_that(text in str(labels), equal_to(True))

@then('I should have {number} slots')
def step_impl_count_slots(context, number):
    number = int(number)
    g = resutils.get_graph_for(context.response.content)
    count = resutils.get_slots_count(g, subject=context.url)
    assert_that(count, equal_to(number))

@then('the response contains {number} number of triples')
def step_impl_count_total_triples(context, number):
    number = int(number)
    g = resutils.get_graph_for(context.response.content)
    count = resutils.get_total_triples_count(g)
    assert_that(count, equal_to(number))

# Christophe tests
@then('a proxy exists for {proxy}')
def step_impl_count_relevant(context, proxy):
    proxy_response = resutils.get_proxy_for(context, proxy)
    assert_that(proxy_response.history[0].status_code , equal_to(303))

    logging.info("proxy <"+proxy+"> --> "+str(proxy_response.url)+"\n")
    context.proxy_key = resutils.clean(proxy)

@then('a proxy doesn\'t exist for {proxy}')
def step_impl_count_relevant(context, proxy):
    proxy_response = resutils.get_proxy_for(context, proxy)
    assert_that(proxy_response, equal_to(None))


@then('The number of relevant entities {types} in the collection should be the same')
def step_impl_relevant(context, types):
    # Retreive proxy response
    proxy_response = resutils.get_proxy_for(context, resutils.clean(context.proxy_key))
    # Count objects on proxy graph
    report = resutils.count_objects_all(resutils.get_graph_for(proxy_response.content))

    # logging.info(json.dumps(context.relevant_dict, indent=1)+"\n")
    # logging.info(json.dumps(report, indent=1)+"\n")

    # Compare proxy's counted objects to relevant dict from previous step count
    flag = resutils.dict_compare(types, report, context.relevant_dict)
    assert_that(flag , equal_to(True))

@then('The proxy is associated with "{uri}"\'s proxy')
def step_impl_associated(context, uri):
    # Retreive new proxy for {uri}
    proxy = resutils.get_proxy_for(context, uri)
    g = resutils.get_graph_for(proxy.content)

    # Retreive already set proxy
    old = resutils.get_proxy_for(context, resutils.clean(context.proxy_key))
    logging.info("old proxy: "+old.url)

    for item in g.objects(subject = URIRef(proxy.url), predicate = config.OLO.slot):
        proxy_str = item.toPython()
        logging.info("proxy_str: "+proxy_str+"\n")
        proxy_uuid = old.url.replace(context.host, "").replace("#id", "")
        logging.info("proxy_uuid: "+proxy_uuid+"\n")

        assert_that(proxy_str, contains_string(proxy_uuid))


@then('The proxy is listed in the graph of "{uri}"\'s proxy')
def step_impl_proxy_listed(context, uri):
    # Retreive new proxy for {uri}
    proxy = resutils.get_proxy_for(context, uri)
    g = resutils.get_graph_for(proxy.content)

    # Retreive already set proxy
    old = resutils.get_proxy_for(context, resutils.clean(context.proxy_key))
    logging.info("old proxy: "+old.url)

    found = False
    for item in g.subjects():
        proxy_str = item.toPython()
        logging.info("proxy_str: "+proxy_str+"\n")
        if proxy_str == old.url :
            found = True
            break

    assert_that(found , equal_to(True))

@then('The proxy is associated to all search results')
def step_impl_listed(context):
    # Retrieve search results
    g = resutils.get_graph_for(context.response.content)
    logging.info(str(len(g))+"\n")

    # Retreive already set proxy
    old = resutils.get_proxy_for(context, resutils.clean(context.proxy_key))
    logging.info("old proxy: "+old.url)

    for item in g.objects(subject=None, predicate=config.OLO.item):
        response = context.session.get(item.toPython(), headers = {'Accept': 'text/turtle'})
        g2 = resutils.get_graph_for(response.content)
        results = resutils.get_slots(g2, item.toPython())
        logging.info(results)
        assert_that(old.url in results, equal_to(True))
