@doubt
Feature: Test against index for media query parametrs

Scenario Outline: Media search
  Given some ingested test data <file>
  Given I search for query <query>
  Given I search for media <media>
  When I request <endpoint>
  Then The response contains an item with label <text>

  Examples:
    | file                | query   | media                                  | endpoint   | text |
    | dracula.nq          | Dracula | http://purl.org/dc/dcmitype/StillImage | everything | Photograph of Count Dracula |
    | dracula.nq          | Dracula | image                                  | everything | Photograph of Count Dracula |
    | dracula.nq          | Dracula | N/A                                      | everything | Photograph of Count Dracula |
