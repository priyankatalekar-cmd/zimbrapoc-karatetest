Feature: Delete email from Zimbra via SOAP

Background:
  * url userSoapUrl


Scenario: Search email and delete by message ID
 ########################### userLogin Receiver ###############################################################
    * def username = 'qauser_892c0c26@qa-u56-singlenode-ps.eng.zimbra.com'
    * def password = 'Welcome123'
    * def authType = 'name'
    * def accountValue = username
    * def env = karate.read('classpath:requests/authRequestUser.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def userAuthToken = karate.xmlPath(response, '//authToken')
    * print 'Auth Token is:', userAuthToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken
    
  # 1. Search email by subject or other criteria
  * def searchQuery = "subject:Hello via SOAP" 
   * def env = karate.read('classpath:requests/searchRequestUser.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200

  # 2. Extract message ID
  * def msgId = response // navigate to the actual ID node, e.g., response.Envelope.Body.SearchResponse.m[0].id
  * print 'Message ID found:', msgId
  
 