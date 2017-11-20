@doubt
Feature: Test against index for audience query parametrs
  Audiences endpoint and filters


Scenario Outline: Audience test (for=)
  Given some ingested test data <file>
  Given I search related media for audience <audience>
  When I request <endpoint>
  Then the response contains an item with label <text>

  Examples:
    | file                  | audience                                      | endpoint   | text |
    | shakespeare-sample.nq | http://shakespeare.acropolis.org.uk/#members  | everything | Accessible only by authorised users in formal education in the UK |

Scenario Outline: Audiences for
  Given Index is empty
  Given some ingested test data <file>
  Given I search related media for audience <audience>
  When I request <endpoint>
  Then I should have <slots> slots

  Examples:
    | file   | audience                                                   | endpoint  | slots |
    | bob_shakespeare.nq | http://bobnational.net/#members                | assets    | 7 |
    | bob_shakespeare.nq | http://shakespeare.acropolis.org.uk/#members   | assets    | 5 |
    | bob_shakespeare.nq | any                                            | assets    | 7 |
    | bob_shakespeare.nq | all                                            | assets    | 5 |
    | bob_shakespeare.nq | any                                            | everything | 16 |


Scenario Outline: Audiences for multiple params
  Given Index is empty
  Given some ingested test data <file>
  Given I search related media for audience list <audiences>
  When I request <endpoint>
  Then I should have <slots> slots

  Examples:
    | file                | audiences                                                                     | endpoint  | slots |
    | bob_shakespeare.nq  | http://bobnational.net/#members                                               | assets    | 7 |
    | bob_shakespeare.nq  | http://shakespeare.acropolis.org.uk/#members                                  | assets    | 5 |
    | bob_shakespeare.nq  | http://bobnational.net/#members,http://shakespeare.acropolis.org.uk/#members  | assets    | 7 |


