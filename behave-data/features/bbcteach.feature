Feature: Test against v1 and v2 of bbcteach
  Testing dataset update


Scenario: Ingest v1
	Given Index is empty
	Given some ingested test data sample.bbcteach.v1.nq
	When I request everything
	Then A proxy exists for "http://bbcteach.acropolis.org.uk/p00xrslk#id"
	And I should have 9 slots

Scenario: Ingest v1 works
	Given Index is empty
	Given some ingested test data sample.bbcteach.v1.nq
	When I request works
	Then A proxy exists for "http://bbcteach.acropolis.org.uk/p00xrslk#id"
	And I should have 4 slots

# Scenario: Ingest v1 - video search
# 	Given Index is empty
# 	Given some ingested test data sample.bbcteach.v1.nq
# 	Given I search for media video
# 	When I request works
# 	Then I should have 2 slots


Scenario: Ingest v2
	Given Index is empty
	Given some ingested test data sample.bbcteach.v1.nq
	Given some ingested test data sample.bbcteach.v2.remove.label.dbpedia.nq
	When I request everything
	Then A proxy exists for "http://bbcteach.acropolis.org.uk/p00xrslk#id"
	And I should have 9 slots

Scenario: Ingest v2 works
	Given Index is empty
	Given some ingested test data sample.bbcteach.v1.nq
	Given some ingested test data sample.bbcteach.v2.remove.label.dbpedia.nq
	When I request works
	Then A proxy exists for "http://bbcteach.acropolis.org.uk/p00xrslk#id"
	And I should have 3 slots

