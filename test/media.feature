Feature: Media
  Media endpoint and filters


Scenario Outline: Media search
  Given some ingested test data <file>
  Given a query <query> and media <media>
  When I request <endpoint>
  Then The response contains <text>

  Examples:
    | file                | query   | media                                  | endpoint   | text |
    | dracula.nq          | Dracula | http://purl.org/dc/dcmitype/StillImage | everything | Photograph of Count Dracula |
