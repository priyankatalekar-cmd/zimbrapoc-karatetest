Feature: Send Email from one Account to Another Account using SOAP API

  Background: 
    * url userSoapUrl

  @SmokeTest1
  Scenario: Send Email from one Account to Another Account using SOAP API and Verify User Received Successfully
    ########################### userLogin Sender###############################################################
    * def username = 'xyz2313490priyankatalekar5@qa-u56-singlenode-ps.eng.zimbra.com'
    * def password = 'Welcome123'
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