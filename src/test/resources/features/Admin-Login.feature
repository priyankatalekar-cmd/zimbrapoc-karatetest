Feature: Login to Zimbra using SOAP API- Admin

  Background: 
    * url adminSoapUrl

  @Sanity
  Scenario Outline: Admin Login- Admin Portal
    * def username = '<username>'
    * def password = '<password>'
    * def soaprequest = karate.read('classpath:requests/authRequest.xml')
    Given request soaprequest
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def authToken = karate.xmlPath(response, '//authToken')
    * print 'Auth Token is:', authToken
    * match authToken != null
    * match authToken != ''

    Examples: 
      | karate.read('classpath:testData/usersAdminValid.csv') |
