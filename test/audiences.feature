Feature: Audiences
    Audiences endpoint and filters


Scenario Outline: Audiences Endpoint
    Given some ingested test data <file>
    When I request <endpoint>
    Then I get a record for <uri>

    Examples:
        | file          | endpoint   | uri |
        | bob-sample.nq | everything | BoB National |


Scenario Outline: Audiences for
    Given some ingested test data <file>
    Given an audience <audience>
    When I request <endpoint>
    Then I should have <slots> slots

    Examples:
        | file   | audience                                                   | endpoint  | slots |
        | bob_shakespeare.nq | http://bobnational.net/#members                | assets    | 4 |
        | bob_shakespeare.nq | http://shakespeare.acropolis.org.uk/#members   | assets    | 2 |
        | bob_shakespeare.nq | any                                            | assets    | 4 |
        | bob_shakespeare.nq | all                                            | assets    | 2 |
        | bob_shakespeare.nq | any                                            | everything | 12 |


Scenario Outline: Audiences for multiple params
    Given some ingested test data <file>
    Given an audience list <audiences>
    When I request <endpoint>
    Then I should have <slots> slots

    Examples:
        | file                | audiences                                                                     | endpoint  | slots |
        | bob_shakespeare.nq  | http://bobnational.net/#members                                               | assets    | 4 |
        | bob_shakespeare.nq  | http://shakespeare.acropolis.org.uk/#members                                  | assets    | 2 |
        | bob_shakespeare.nq  | http://bobnational.net/#members,http://shakespeare.acropolis.org.uk/#members  | assets    | 4 |
