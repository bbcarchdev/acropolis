#encoding: utf-8
Feature: Manually ingesting open data into Acropolis

	Besides the crawling process, system administrators should be able
	to manually ingest data they have vetted as being openly licensed.

	Rules:
		- The data must be externally validated as open data. No additional
		check will be performed as part of the ingest.

Scenario: Number of proxies in the collection
	When I count the amount of relevant entities that are ingested
	And A proxy exists for "http://shakespeare.acropolis.org.uk/#id"
	Then The number of relevant entities in the collection should be the same

Scenario: Associated media
	When A proxy exists for "http://shakespeare.acropolis.org.uk/images/6731510#id"
	And The proxy is associated with "http://dbpedia.org/resource/Judi_Dench"'s proxy
	And The proxy is listed in the graph of "http://dbpedia.org/resource/Judi_Dench"'s proxy

Scenario: Media correctly licensed
	When I search for media for "http://shakespeare.acropolis.org.uk/#members"
	And A proxy exists for "http://shakespeare.acropolis.org.uk/images/6731510#id"
	Then The proxy is listed in the search results
