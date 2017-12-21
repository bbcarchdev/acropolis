from enum import Enum
from rdflib import Namespace

LOCALHOST = "http://localhost/"
LIVE = "http://acropolis.org.uk/"
NA = "N/A"

acropolis_twine_remote = "http://localhost:8000"
acropolis_twine_remote_ingest = acropolis_twine_remote + '/ingest'
acropolis_twine_remote_delete = acropolis_twine_remote + '/delete'


DCMITYPE = Namespace("http://purl.org/dc/dcmitype/")
EVENT = Namespace("http://purl.org/NET/c4dm/event.owl#")
GEO = Namespace("http://www.w3.org/2003/01/geo/wgs84_pos#")
CRM = Namespace("http://www.cidoc-crm.org/cidoc-crm/")
FRBR = Namespace("http://purl.org/vocab/frbr/core#")
OLO = Namespace("http://purl.org/ontology/olo/core#")
SCHEMA = Namespace("http://schema.org/")

class Partition(Enum):
    AGENTS='agents'
    AUDIENCES='audiences'
    DIGITAL_ASSETS='assets'
    COLLECTIONS='collections'
    CONCEPTS='concepts'
    EVENTS='events'
    GROUPS='groups'
    PEOPLE='people'
    PLACES='places'
    PHYSICAL_THING='things'
    WORKS='works'
    EVERYTHING='everything'
    ROOT='index'

class MediaType(Enum):
    VIDEO='video'
    AUDIO='audio'
    IMAGE='image'


