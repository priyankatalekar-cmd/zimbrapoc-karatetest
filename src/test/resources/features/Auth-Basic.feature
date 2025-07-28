Feature: Send Email from one account to another using SOAP API

  Background: 
    * configure ssl = true
    * def result = call read('classpath:features/CreateAccount.feature')
    * def createdEmail = result.email
    * def createdId = result.accountId
    * def foreignPrincipal = result.foreignPrincipal

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
