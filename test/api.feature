Feature: API
  Basic endpoint and filters tests


Scenario Outline: API Endpoints
  Given some ingested test data <file>
  When I request <endpoint>
  Then The response contains <text>

  Examples:
    | file                  | endpoint    | text |
    | bob-sample.nq         | everything  | BoB National |
    | shakespeare-sample.nq | works       | Henry V |
    | shakespeare-sample.nq | collections | BBC Shakespeare Archive Resource |
    | shakespeare-sample.nq | agents      | Agents |
    | shakespeare-sample.nq | things      | Physical things |
    | shakespeare-sample.nq | people      | Robert Hardy |
    | shakespeare-sample.nq | audiences   | Authorised users of the BBC Shakespeare Archive Resource |
    | shakespeare-sample.nq | concepts    | http://acropolis.localhost/concepts |
    | shakespeare-sample.nq | groups      | http://acropolis.localhost/groups |
    | bob-sample.nq         | events      | The Andrew Marr Show |
    | dracula.nq            | places      | http://acropolis.localhost/places |
    | dracula.nq            | assets      | Photograph of Count Dracula |

Scenario Outline: API Endpoints with filters
  Given some ingested test data <file>
  When I request <endpoint>
  And I supply the parameter <name> <value>
  Then The response contains <text>

  Examples:
    | file                  | endpoint    | name | value | text |
    | shakespeare-sample.nq | everything  | q    | judi  | Judi Dench |
