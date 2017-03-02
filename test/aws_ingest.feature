Feature: AWS Ingest
  Ingest test data into aws and compare it with local dev stack

# Due to inability with in aws to perform operations(ingest test data), this test would focus only on local dev stack
# for now.

Scenario Outline: Ingest and retrieve RDF data on local instance
  Given some ingested test data <file>
  Given I accept content as <content>
  When I request <endpoint>
  Then The response contains <count> number of triples

  Examples:
    | file                | content     | endpoint   | count  |
    | dracula.nq          | text/html   | everything | 104    |
