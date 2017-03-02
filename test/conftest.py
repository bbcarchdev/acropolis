import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

rdfs = Namespace("http://www.w3.org/2000/01/rdf-schema#")
olo = Namespace("http://purl.org/ontology/olo/core#")

acropolis_quilt = "http://acropolis.localhost"
acropolis_twine_remote = "http://acropolis:8000/ingest"

ingested = {}

@pytest.fixture
def context():
  return {
    'params' : {},
    'headers' : {
      'Accept': 'application/json',
    },
    'response': None,
  }

@given("I accept content as <content>")
def accept_content(context, content):
  context['headers']['Accept'] = content

@given("some ingested test data <file>")
def ingest(file):
  if file in ingested:
    return
  headers = {
    'Content-Type': 'text/x-nquads'
  }
  with open("data/" + file, 'r') as f: 
    ingested[file] = requests.post(acropolis_twine_remote, headers=headers, data=f.read())


@when("I supply the parameter <name> <value>")
def set_parameter(context, name, value):
  context['params'][name] = value


@when("I request <endpoint>")
def request_endpoint(context, endpoint):
  uri = '{}/{}'.format(acropolis_quilt, endpoint)
  context['response'] = requests.get(uri, headers=context['headers'], params=context['params'])
  context['uri'] = context['response'].request.url


@then("The response contains <text>")
def check_record_contains(context, text):
  print( context['response'].text )
  assert text in context['response'].text


@then("I get a record for <uri>")
def check_record_contains_uri(context, uri):
  assert uri in context['response'].text


@then("I should have <slots> slots")
def check_slots(context, slots):
  o = context['response'].json()
  uri = context['response'].request.url

  olo_slots = o[uri].get(str(olo.slot),[])
  assert int(slots) == len(olo_slots)
  print("Slots: {}".format(len(slots)))
  for slot in olo_slots:
    slot = o[slot['value']]
    item = slot['http://purl.org/ontology/olo/core#item'][0]['value']
    concept = o[item]
    label = concept['http://www.w3.org/2000/01/rdf-schema#label']
    print("id: {}, label: {}".format(item, label[0]['value']))
