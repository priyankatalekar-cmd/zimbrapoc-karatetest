Feature: Create a Account using Admin Console & Login into Web Client by various authTypes

  #Steps:
  # Create a Account using Admin Console
  # Login into Web Client by various authTypes
  Background: 
    #===================================================Common Configurations================================================================================
    * configure ssl = true
    # Accept passed variables with defaults
    * def Tag = karate.get('Tag', 'name')

  @Common_Login
  Scenario: Login into Client using various account by name
    #============================================================Common User Login==============================================================================
    * def result = call read('classpath:features/Create-User-Accounts.feature@Common_AccountCreation')
    * def createdEmail = result.email
    * def createdId = result.accountId
    * def foreignPrincipal = result.foreignPrincipal
    * url userSoapUrl
    * def username = createdEmail
    * def password = 'Welcome123'
    * def tag =  'name'
    * def value = tag == 'name' ? username : (tag == 'id' ? createdId : foreignPrincipal)
    * def loginRequest = karate.readAsString('classpath:requests/authRequestUser.xml')
    * def loginRequest = loginRequest.replace('#(authType)', tag)
    * def loginRequest = loginRequest.replace('#(accountValue)', value)
    * def loginRequest = loginRequest.replace('#(password)', password)
    * print loginRequest
    #=========================================================Web Client Admin Login==============================================================================
    Given request loginRequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def result = call read('classpath:features/Common-Assertions.feature@UserAuth-CSFRToken')
    * def authToken = result.userAuthToken
    * print authToken
    * def csfrToken = result.csfrToken
    * print csfrToken

  @Sanity
  Scenario Outline: Login into Client using various account by tags
    #============================================================Common User Login==============================================================================
    * def loginResponse = call read('classpath:features/Create-User-Accounts.feature@Account_WithzimbraForeignPrincipal')
    * def createdEmail = loginResponse.accountName
    * def createdId = loginResponse.accountId
    * def foreignPrincipal = loginResponse.foreignPrincipal
    * url userSoapUrl
    * def username = createdEmail
    * def password = 'Welcome123'
    * def tag = '<Tag>'
    * def value = tag == 'name' ? username : (tag == 'id' ? createdId : foreignPrincipal)
    * def loginRequest = karate.readAsString('classpath:requests/authRequestUser.xml')
    * def loginRequest = loginRequest.replace('#(authType)', tag)
    * def loginRequest = loginRequest.replace('#(accountValue)', value)
    * def loginRequest = loginRequest.replace('#(password)', password)
    * print loginRequest
    #=========================================================Web Client Admin Login==============================================================================
    Given request loginRequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def result = call read('classpath:features/Common-Assertions.feature@UserAuth-CSFRToken')

    Examples: 
      | Tag              |
      | name             |
      | id               |
      | foreignPrincipal |
