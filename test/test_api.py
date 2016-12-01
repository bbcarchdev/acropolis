import pytest
import requests
import urllib.parse
from pytest_bdd import scenario, given, when, then, parsers, scenarios
from rdflib import Namespace

scenarios('api.feature')
