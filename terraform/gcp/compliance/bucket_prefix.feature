Scenario: Ensure all storage buckets resources contains project id
    Given I have a google_storage_bucket defined
    When it has name
    Then its value must contain serverless-labs-328806
