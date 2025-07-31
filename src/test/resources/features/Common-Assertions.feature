Feature: Common Assertions

 @Verify_CreateAccountResponse
  Scenario: Verify Create Contact Response
    * match accountId != null
    * match accountId != ''
    * def accountName = karate.xmlPath(response, "//account/@name")
    * print 'Created Account Name:', accountName
    * match accountName == email

  @Verify_Contact
  Scenario: Verify Create Contact Response
    # Extract each value directly from the full XML response:
    * def contactId = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/@id")
    * def fileAsStr = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/@fileAsStr")
    * def firstName = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='firstName']")
    * def lastName = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='lastName']")
    * def company = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='company']")
    * def email = karate.xmlPath(response, "//*[local-name()='CreateContactResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='email']")
    * match contactId != null
    * assert parseInt(contactId) > 0
    * match firstName == contactData.firstName
    * match lastName == contactData.lastName
    * match email == contactData.email
    * match company == contactData.company

  @Verify_HTTP_200_OK
  Scenario: Verify HTTP 200 OK status
    * match responseStatus == 200

  @Verify_HTTP_500_INVALID
  Scenario: Verify HTTP 500 INVALID status
    * match responseStatus == 500

  @UserAuth-CSFRToken
  Scenario: Fetch AuthToken and CSFR Token
    * def userAuthToken = karate.xmlPath(response, '//authToken')
    * print 'User Auth Token:', userAuthToken
    * match userAuthToken != null
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken
    * match csfrToken != null
     # Return tokens explicitly to caller
  * def result = { userAuthToken: userAuthToken, csfrToken: csfrToken }
  
  @Verify_SearchResponse
  Scenario: Verify Search Response
    # Extract each value directly from the full XML response:
    * def contactId = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/@id")
    * def fileAsStr = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/@fileAsStr")
    * def firstName = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='firstName']")
    * def lastName = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='lastName']")
    * def company = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='company']")
    * def email = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='cn'][1]/*[local-name()='a'][@n='email']")
    * match contactId != null
    * assert parseInt(contactId) > 0
    * match firstName == contactData.firstName
    * match lastName == contactData.lastName
    * match email == contactData.email
    * match company == contactData.company
 
