Feature: Audiences
  Audiences endpoint and filters


Scenario Outline: Media correctly licensed
  Given some ingested test data <file>
  Given an audience <audience>
  When I request <endpoint>
  Then I get a record for <uri>

  Examples:
    | file                  | audience                                      | endpoint   | uri |
    | shakespeare-sample.nq | http://shakespeare.acropolis.org.uk/#members  | everything | http://acropolis.localhost/72ae752c83ee4968a70ae80f6c22f2b7#id |


Scenario Outline: Audiences for
  Given some ingested test data <file>
  Given an audience <audience>
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
  Given some ingested test data <file>
  Given an audience list <audiences>
  When I request <endpoint>
  Then I should have <slots> slots

  Examples:
    | file                | audiences                                                                     | endpoint  | slots |
    | bob_shakespeare.nq  | http://bobnational.net/#members                                               | assets    | 7 |
    | bob_shakespeare.nq  | http://shakespeare.acropolis.org.uk/#members                                  | assets    | 5 |
    | bob_shakespeare.nq  | http://bobnational.net/#members,http://shakespeare.acropolis.org.uk/#members  | assets    | 7 |
