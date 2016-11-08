Feature: Audiences
    Audiences endpoint and filters

Scenario Outline: Audiences Endpoint
    Given some ingested test data <file>
    When I request <endpoint>
    Then I get a record for <uri>

    Examples:
        | file   | endpoint   | uri |
        | bob.nq | everything | BoB National |

Scenario Outline: Audiences for
    Given some ingested test data <file>
    Given an audience <audience>
    When I request <endpoint>
    Then I should have <slots> slots

    Examples:
        | file   | audience                                                   | endpoint   | slots |
        | bob_shakespeare.nq | http://bobnational.net/#members                | everything | 8 |
        | bob_shakespeare.nq | http://shakespeare.acropolis.org.uk/#members   | everything | 10 |
        | bob_shakespeare.nq | any                                            | everything | 12 |
        | bob_shakespeare.nq | all                                            | everything | 6 |
