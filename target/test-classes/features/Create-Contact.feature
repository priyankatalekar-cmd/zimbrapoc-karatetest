Feature: Create a Contact

  Background: 
    * def DataFaker = Java.type('com.github.javafaker.Faker')
    * def faker = new DataFaker()
    * def DataGenerator = Java.type('utils.DataGenerator')

  @Sanity
  Scenario: Create a Contact
    #  * def includeAccountTag = karate.get('includeAccountTag', false)
    #  * def result = call read('classpath:features/CreateAccount.feature')
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = result.userAuthToken
    * def csrfToken = result.csfrToken
    * def firstName = DataGenerator.getRandomFirstName()
    * def lastName = DataGenerator.getRandomLastName()
    * def email = 'email@gmail.com'
    * def company = 'XYZ'
    * url userSoapUrl
    * def soaprequest = karate.read('classpath:requests/createContactRequest.xml')
    Given request soaprequest
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    # Extract contact ID using XPath
    * def contactId = karate.xmlPath(response, '//cn/@id')
    * print 'Contact ID:', contactId
    # Verify contact ID is not null
		* assert contactId != null && contactId != '' && typeof contactId == 'string'
    # Additional verification - ensure it's numeric
    * def contactIdAsNumber = parseInt(contactId)
    * assert contactIdAsNumber > 0
