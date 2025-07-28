Feature: Create a Contact

  @Sanity
  Scenario: Create a Contact
    * def includeAccountTag = karate.get('includeAccountTag', false)
    * def result = call read('classpath:features/CreateAccount.feature')
    * 