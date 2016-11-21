import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

rdfs = Namespace("http://www.w3.org/2000/01/rdf-schema#")
olo = Namespace("http://purl.org/ontology/olo/core#")

acropolis_quilt = "http://acropolis.localhost:80"
acropolis_twine_remote = "http://acropolis.localhost:8000/ingest"

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
    ingested[file] = requests.post(acropolis_twine_remote, headers=headers, data=f.read())


@given("an audience <audience>")
def for_audience(context, audience):
  context['query'] = "?for={}".format(urllib.parse.quote(audience))
  print(context['query'])


@given("an audience list <audiences>")
def for_audience(context, audiences):
  context['query'] = "?for={}".format(urllib.parse.quote(audiences))
  print(context['query'])


@when("I request <endpoint>")
def request_endpoint(context, endpoint):
  headers = {
    'Accept': 'application/json',
  }
  uri = '{}/{}{}'.format(acropolis_quilt, endpoint,  context['query'])
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
