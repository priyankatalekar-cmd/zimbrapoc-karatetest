@CreateContact
Feature: Create a Contact

  Background:
#===================================================Common Configurations================================================================================ 
    * def DataFaker = Java.type('com.github.javafaker.Faker')
    * def faker = new DataFaker()
    * def DataGenerator = Java.type('utils.DataGenerator')
    # Generate contact data
    * def contactData = DataGenerator.getCompleteContactData()
    * configure ssl = true

  @Sanity
  Scenario: Create a Contact with basic fields
#====================================================Common Account Creation & Login=================================================================
    #  * def includeAccountTag = karate.get('includeAccountTag', false)
    #  * def result = call read('classpath:features/CreateAccount.feature')
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    # * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
    * def loginResponse = call read('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = loginResponse.authToken
    * def csfrToken = loginResponse.csfrToken
#=====================================================Configure Data As per Request====================================================================
    # Configuration flags
    * def includeExtendedFields = false
    * def includePhoneFields = false
    * def includeAddressFields = false
    # Set base tags (always included)
    * karate.set('baseTags', '<a n="firstName">' + contactData.firstName + '</a><a n="lastName">' + contactData.lastName + '</a><a n="email">' + contactData.email + '</a><a n="company">' + contactData.company + '</a>')
    * if (!includeExtendedFields) karate.set('extendedTags', '')
    * if (!includePhoneFields) karate.set('phoneTags', '')
    * if (!includeAddressFields) karate.set('addressTags', '')
    # Read template and replace tokens
    * def soapTemplate = karate.readAsString('classpath:requests/createContactRequest.xml')
    * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
    * def finalRequest = finalRequest.replace('#(csfrToken)', csfrToken)
    * def finalRequest = finalRequest.replace('#(baseTags)', baseTags)
    * def finalRequest = finalRequest.replace('#(extendedTags)', extendedTags)
    * def finalRequest = finalRequest.replace('#(phoneTags)', phoneTags)
    * def finalRequest = finalRequest.replace('#(addressTags)', addressTags)
    * print finalRequest
    
#=================================================Create Contact API Call==============================================================================
    * url userSoapUrl
    Given request finalRequest
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
#=====================================================Assertion=======================================================================================
    * def result = call read('classpath:features/Common-Assertions.feature@Verify_Contact')
#==================================================== GetContact API Call=============================================================================
    * def attributeName = contactData.firstName
    * def soaprequest = karate.read('classpath:requests/getContactRequest.xml')
    Given request soaprequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
#======================================================SearchContact===================================================================================
    * def searchQuery = contactData.firstName
    * def typeValue = 'contact'
    * def soaprequest = karate.read('classpath:requests/searchRequest.xml')
    Given request soaprequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
#========================================================Verify Search Response==========================================================================
    * def result = call read('classpath:features/Common-Assertions.feature@Verify_SearchResponse')
