import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

scenarios('audiences.feature')

@given("an audience <audience>")
def for_audience(context, audience):
  context['query'] = "?for={}".format(urllib.parse.quote(audience))
  print(context['query'])


@given("an audience list <audiences>")
def for_audience_list(context, audiences):
  context['query'] = ""
  for audience in audiences.split(','):
    if context['query']:
      context['query'] = context['query'] + "&"
    else:
      context['query'] = context['query'] + "?"
    context['query'] = context['query'] + "for={}".format(urllib.parse.quote(audience))
  print(context['query'])
