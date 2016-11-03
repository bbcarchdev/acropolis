#encoding: utf-8
Feature: Manually ingesting open data into Acropolis 

	Besides the crawling process, system administrators should be able
	to manually ingest data they have vetted as being openly licensed.
	
	Rules:
		- The data must be externally validated as open data. No additional 
		check will be performed as part of the ingest.
		
Scenario Outline: Ingesting a single nquad 
	Given an empty instance of Acropolis 
	When we ingest the data dump "<file>" 
	Then a proxy resource for "<name>" is created in the DB
	And a web representation of "<name>" is accessible
	
	Examples: Test files
		| file | name |
		| Iceland.nq | Iceland |
		