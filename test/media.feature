Feature: Media
    Media endpoint and filters


Scenario Outline: Media search
    Given some ingested test data <file>
    Given a query <query> and media <media>
    When I request <endpoint>
		Then I get a record for <uri>

    Examples:
        | file                | query   | media                                  | endpoint  | uri |
        | dracula.nq          | Dracula | http://purl.org/dc/dcmitype/StillImage |           | http://acropolis.localhost/?q=Dracula&media=http%3A//purl.org/dc/dcmitype/StillImage |
