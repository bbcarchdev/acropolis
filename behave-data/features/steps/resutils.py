import os
from collections import Counter
import requests
from rdflib import Graph, ConjunctiveGraph, URIRef, Namespace
from rdflib.namespace import RDF, RDFS, FOAF, SKOS, VOID
import config
import logging
from time import sleep

def ingest_data(context, data):
    r = context.session.post(config.acropolis_twine_remote_ingest, data=data, headers = {'Content-Type': 'text/x-nquads'})
    context.response = r
    sleep(1)
    return context

def clear_index(context):
    r = context.session.post(config.acropolis_twine_remote_delete)
    context.ingested.clear()
    sleep(1)
    return context

def get_graph_for(data):
    g = Graph()
    g.parse(data=data, format="turtle")
    return g

def get_partition_labels(graph, subject):
    labels = []
    for label in graph.objects(subject=None, predicate=RDFS.label):
        labels.append(label.toPython())
    return labels

def get_slot_labels(graph, subject):
    labels = []
    for item in graph.objects(subject=URIRef(subject), predicate=RDFS.seeAlso):
      for label in graph.objects(subject=item, predicate=RDFS.label):
        labels.append(label)
    return labels

def get_slots_count(graph, subject):
    for item in graph.objects(subject=URIRef(subject), predicate=RDFS.seeAlso):
        logging.info(item)

    return sum(1 for item in graph.objects(subject=URIRef(subject), predicate=RDFS.seeAlso))

def get_slots(graph, subject):
    itemList = []
    # logging.info(subject)
    # logging.info(type(subject))
    for item in graph.objects(subject=URIRef(subject), predicate=RDFS.seeAlso):
        itemList.append(item.toPython())
    return itemList


def get_total_triples_count(graph):
    count = 0
    for item in graph.objects(subject=None, predicate=RDFS.seeAlso):
        session = requests.Session()
        response = session.get(str(item), headers = {'Accept': 'text/turtle'})
        g = get_graph_for(response.content)
        logging.info(str(item) + "->" + str(len(g)))
        count = count + len(g)
    return count

def count_objects(typesList, graph):
    report = {}
    for typeItem in typesList:
        count = len(list(graph.subjects(predicate=RDF.type, object=typeItem)))
        report[str(typeItem)] = count
    return report

def count_objects_all(graph):
    report = {}
    temp_list = []
    for item in graph.objects(predicate=RDF.type):
        # logging.info("Object type:"+item+"\n")
        temp_list.append(item)

    return dict(Counter(temp_list))

def dict_compare(typesList, dictA, dictB):
    for typeItem in typesList:
        if (typeItem in dictA) & (typeItem in dictB):
            if dictA[typeItem] != dictB[typeItem]:
                return False

    return True

# Returns full Response object
def get_proxy_for(context, uri):

   if clean(uri) in context.proxydict.keys():
       return context.proxydict[clean(uri)]
   else:
        proxy = context.session.get(context.host , headers = {'Accept': 'text/turtle'}, params = {'uri': clean(uri) } )
        if proxy.status_code == 404 :
            return None
        else:
            context.proxydict[clean(uri)] = proxy
            return proxy

def clean(uri):
    return uri.strip('\'"\t\r\n')
