@sample
Feature: Test against dataset samples
  Testing dataset samples

## BBC Images

# Scenario: Verify proxies in BBCImages
# 	Given Index is empty
# 	Given some ingested test data sample.bbcimages.nq
# 	When I request everything
# 	When I count the amount of relevant entities that are ingested
# 	Then a proxy exists for 'http://bbcimages.acropolis.org.uk/#id'
# 	And The number of relevant entities [config.SCHEMA.Photograph] in the collection should be the same


Scenario Outline: Count proxies in BBCImages
  Given Index is empty
  Given some ingested test data sample.bbcimages.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 2     |
    | collections    | 1     |
    | assets         | 4     |

## BBC Remarc

Scenario Outline: Count proxies in Remarc
  Given Index is empty
  Given some ingested test data sample.remarc.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 3     |
    | collections    | 4     |
    | assets         | 6     |

## BBC Teach

Scenario Outline: Count proxies in BBC Teach
  Given Index is empty
  Given some ingested test data sample.bbcteach.v1.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 4     |
    | collections    | 1     |
    | assets         | 2     |

## BBC Sound Effects

Scenario Outline: Count proxies in Sound Effects
  Given Index is empty
  Given some ingested test data sample.bbcsfx.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 2     |
    | collections    | 1     |
    | assets         | 2     |

# ## BBC Worldwide

Scenario Outline: Count proxies in BBC Worldwide
  Given Index is empty
  Given some ingested test data sample.worldwide.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 2     |
    | collections    | 1     |
    | assets         | 2     |

## BBC Wildlife

Scenario Outline: Count proxies in BBC Wildlife
  Given Index is empty
  Given some ingested test data sample.wildlife.nq
  When I request <endpoint>
  Then I should have <count> slots

  Examples:
    | endpoint       | count |
    | works          | 0     |
    | collections    | 1     |
    | assets         | 7     |
