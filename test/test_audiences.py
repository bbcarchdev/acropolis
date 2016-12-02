import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

scenarios('audiences.feature')

@given("an audience <audience>")
def for_audience(context, audience):
  context['params']['for'] = audience


@given("an audience list <audiences>")
def for_audience_list(context, audiences):
  context['params']['for'] = audiences.split(',')
