Feature: Manually ingesting open data into Acropolis

	Besides the crawling process, system administrators should be able
	to manually ingest data they have vetted as being openly licensed.

	Rules:
		- The data must be externally validated as open data. No additional
		check will be performed as part of the ingest.

Scenario: Number of proxies in the collection
	Given Index is empty
	Given some ingested test data shakespeare-sample.nq
	When I request everything
	When I count the amount of relevant entities that are ingested
	Then a proxy exists for 'http://shakespeare.acropolis.org.uk/#id'
	And The number of relevant entities in the collection should be the same

Scenario: Associated media
	Given some ingested test data shakespeare-sample.nq
	When I request everything
	Then A proxy exists for "http://shakespeare.acropolis.org.uk/images/6731510#id"
	And The proxy is associated with "http://dbpedia.org/resource/Judi_Dench"'s proxy
	And The proxy is listed in the graph of "http://dbpedia.org/resource/Judi_Dench"'s proxy

Scenario: Media correctly licensed
	Given some ingested test data shakespeare-sample.nq
	Given I search related media for audience "http://shakespeare.acropolis.org.uk/#members"
	When I request everything
	Then A proxy exists for "http://shakespeare.acropolis.org.uk/images/6731510#id"
	Then The proxy is associated to all search results

Scenario: Proxy missing
	Given some ingested test data shakespeare-sample.nq
	When I request everything
	Then A proxy doesn't exist for "http://shakespeare.acropolis.org.uk/images/XXXXXX#id"
