import requests
import urllib.parse;

from rdflib import Namespace

rdfs = Namespace("http://www.w3.org/2000/01/rdf-schema#")
olo = Namespace("http://purl.org/ontology/olo/core#")


audiences = [
  'http://bobnational.net/#members',
  'http://shakespeare.acropolis.org.uk/#members',
  'http://bobnational.net/#members,http://shakespeare.acropolis.org.uk/#members',
  'any',
  'all',
]

for audience in audiences:
  headers = {
    'Accept': 'application/json',
  }
  local_uri = 'http://acropolis.localhost/everything?for={}'.format(urllib.parse.quote(audience))
  uri = 'http://acropolis.localhost/everything?for={}'.format(urllib.parse.quote(audience))
  r = requests.get(local_uri, headers=headers)

  # r.status_code
  # r.headers['content-type']
  # r.encoding
  o = r.json()

  print("-" * 80)
  print(uri)
  for key in o:
    print("Key {}".format(key))
  slots = o[uri].get(str(olo.slot),[])
  print("Slots: {}".format(len(slots)))
  for slot in slots:
    slot = o[slot['value']]
    item = slot['http://purl.org/ontology/olo/core#item'][0]['value']
    concept = o[item]
    label = concept['http://www.w3.org/2000/01/rdf-schema#label']
    print("id: {}, label: {}".format(item, label[0]['value']))
