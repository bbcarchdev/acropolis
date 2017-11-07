Feature: RES API partitions
  Testing against partition existence and label

Background: Root request
  When I request root

Scenario Outline: API Endpoints
    Then the response contains a partition with label <text>

  Examples:
    | text            |
    | Agents          |
    | People          |
    | Audiences       |
    | Groups          |
    | Digital assets  |
    | Collections     |
    | Places          |
    | Events          |
    | Concepts        |
    | Physical things |
    | Creative works  |
    | Everything      |



