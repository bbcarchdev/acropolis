@doubt
Feature: Ingestion triples
  Ingest test data and count expected triples


Scenario Outline: Ingest and count added triples
  Given Index is empty
  Given some ingested test data <file>
  Given I accept content as <content>
  When I request <endpoint>
  Then the response contains <count> number of triples

  Examples:
    | file                | content     | endpoint   | count  |
    | dracula.nq          | text/turtle | everything | 156    |
