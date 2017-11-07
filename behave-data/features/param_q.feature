Feature: Test against index for text query parametrs

  In order to verify asset retrieval
  As a consumer of RES API
  I want to find creative works containing 'african' keyword

Scenario Outline: Text search
  Given some ingested test data <file>
  Given I search for query <query>
  When I request <partition>
  Then the response contains an item with label <text>


  Examples:
    | file                  | query   | partition   | text                                                      |
    | bbcsfx-00008000.nq           | african | works       | 'African market'                                          |
    | shakespeare-sample.nq | judi    | everything  | 'Judi Dench'                                              |
    | shakespeare-sample.nq | judi    | people      | 'Judi Dench'                                              |
    | shakespeare-sample.nq | N/A     | works       | Henry V                                                   |
    | shakespeare-sample.nq | N/A     | collections | BBC Shakespeare Archive Resource                          |
    | shakespeare-sample.nq | N/A     | people      | Robert Hardy                                              |
    | shakespeare-sample.nq | N/A     | audiences   | Authorised users of the BBC Shakespeare Archive Resource  |
    | bob-sample.nq         | N/A     | everything  | BoB National                                              |
    | bob-sample.nq         | N/A     | events      | The Andrew Marr Show                                      |
    | dracula.nq            | N/A     | assets      | Photograph of Count Dracula                               |
