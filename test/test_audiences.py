import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

rdfs = Namespace("http://www.w3.org/2000/01/rdf-schema#")
olo = Namespace("http://purl.org/ontology/olo/core#")

scenarios('audiences.feature')

ingested = {}

@pytest.fixture
def context():
  return {
    'uri': '',
    'query': '',
    'response': None,
  }


@given("some ingested test data <file>")
def ingest(file):
  if file in ingested:
    return
  headers = {
    'Content-Type': 'text/x-nquads'
  }
  with open("data/" + file, 'r') as f: 
    uri = 'http://twine:8000/ingest'
    ingested[file] = requests.post(uri, headers=headers, data=f.read())


@given("an audience <audience>")
def for_audience(context, audience):
  context['query'] = "?for={}".format(urllib.parse.quote(audience))
  print(context['query'])


@when("I request <endpoint>")
def request_endpoint(context, endpoint):
  headers = {
    'Accept': 'application/json',
  }
  uri = 'http://acropolis.localhost/{}{}'.format(endpoint, context['query'])
  context['uri'] = uri
  context['response'] = requests.get(uri, headers=headers)


@then("I get a record for <uri>")
def check_record_contains(context, uri):
  assert uri in context['response'].text


@then("I should have <slots> slots")
def check_slots(context, slots):
  o = context['response'].json()
  uri = context['uri']

  olo_slots = o[uri].get(str(olo.slot),[])
  assert int(slots) == len(olo_slots)
  print("Slots: {}".format(len(slots)))
  for slot in olo_slots:
    slot = o[slot['value']]
    item = slot['http://purl.org/ontology/olo/core#item'][0]['value']
    concept = o[item]
    label = concept['http://www.w3.org/2000/01/rdf-schema#label']
    print("id: {}, label: {}".format(item, label[0]['value']))
