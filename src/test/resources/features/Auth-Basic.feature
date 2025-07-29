Feature: Create a Account using Admin Console & Login into Web Client by various authTypes

  #Steps:
  # Create a Account using Admin Console
  # Login into Web Client by various authTypes
  Background: 
    * configure ssl = true
    * def result = call read('classpath:features/Create-User-Account.feature')
    * def createdEmail = result.email
    * def createdId = result.accountId
    * def foreignPrincipal = result.foreignPrincipal
    # Accept passed variables with defaults
    * def Tag = karate.get('Tag', 'name')
    * def includeAccountTag = karate.get('includeAccountTag', 'False')

  @Common_Login
  Scenario: Login into Client using various account by name
    * url userSoapUrl
    * def username = createdEmail
    * def password = 'Welcome123'
    * def tag = Tag
    * def value = tag == 'name' ? username : (tag == 'id' ? createdId : foreignPrincipal)
    * def loginRequest = karate.readAsString('classpath:requests/authRequestUser.xml')
    * def loginRequest = loginRequest.replace('#(authType)', tag)
    * def loginRequest = loginRequest.replace('#(accountValue)', value)
    * def loginRequest = loginRequest.replace('#(password)', password)
    * print loginRequest
    Given request loginRequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def userAuthToken = karate.xmlPath(response, '//authToken')
    * print 'User Auth Token:', userAuthToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken

  @Sanity
  Scenario Outline: Login into Client using various account by tags
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
    Given request loginRequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def userAuthToken = karate.xmlPath(response, '//authToken')
    * print 'User Auth Token:', userAuthToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken

    Examples: 
      | Tag              |
      | name             |
      | id               |
      | foreignPrincipal |
