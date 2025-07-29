Feature: Create a Contact

  Background: 
    * def DataFaker = Java.type('com.github.javafaker.Faker')
    * def faker = new DataFaker()
    * def DataGenerator = Java.type('utils.DataGenerator')
    # Generate contact data
    * def contactData = DataGenerator.getCompleteContactData()

  @Sanity
  Scenario: Create a Contact with basic fields
    #  * def includeAccountTag = karate.get('includeAccountTag', false)
    #  * def result = call read('classpath:features/CreateAccount.feature')
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = result.userAuthToken
    * def csfrToken = result.csfrToken
    # Configuration flags
    * def includeExtendedFields = false
    * def includePhoneFields = false
    * def includeAddressFields = false
    # Set base tags (always included)
    * karate.set('baseTags', '<a n="firstName">' + contactData.firstName + '</a><a n="lastName">' + contactData.lastName + '</a><a n="email">' + contactData.email + '</a><a n="company">' + contactData.company + '</a>')
    * if (includeExtendedFields) karate.set('extendedTags', '<a n="middleName">' + contactData.middleName + '</a><a n="jobTitle">' + contactData.jobTitle + '</a><a n="email2">' + contactData.email2 + '</a>')
    * if (!includeExtendedFields) karate.set('extendedTags', '')
    # Conditionally set phone tags
    * if (includePhoneFields) karate.set('phoneTags', '<a n="workPhone">' + contactData.workPhone + '</a><a n="homePhone">' + contactData.homePhone + '</a><a n="mobilePhone">' + contactData.mobilePhone + '</a>')
    * if (!includePhoneFields) karate.set('phoneTags', '')
    # Conditionally set address tags
    * if (includeAddressFields) karate.set('addressTags', '<a n="workStreet">' + contactData.workStreet + '</a><a n="workCity">' + contactData.workCity + '</a><a n="workState">' + contactData.workState + '</a>')
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
    * url userSoapUrl
    #   * def soaprequest = karate.read('classpath:requests/createContactRequest.xml')
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

  @Sanity
  Scenario: Create a Contact with all fields
    #  * def includeAccountTag = karate.get('includeAccountTag', false)
    #  * def result = call read('classpath:features/CreateAccount.feature')
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = result.userAuthToken
    * def csfrToken = result.csfrToken
    # Generate contact data
    * def contactData = DataGenerator.getCompleteContactData()
    # Configuration flags
    * def includeExtendedFields = true
    * def includePhoneFields = true
    * def includeAddressFields = false
    # Set base tags (always included)
    * karate.set('baseTags', '<a n="firstName">' + contactData.firstName + '</a><a n="lastName">' + contactData.lastName + '</a><a n="email">' + contactData.email + '</a><a n="company">' + contactData.company + '</a>')
    # Conditionally set extended tags
    * if (includeExtendedFields) karate.set('extendedTags', '<a n="middleName">' + contactData.middleName + '</a><a n="jobTitle">' + contactData.jobTitle + '</a><a n="email2">' + contactData.email2 + '</a>')
    * if (!includeExtendedFields) karate.set('extendedTags', '')
    # Conditionally set phone tags
    * if (includePhoneFields) karate.set('phoneTags', '<a n="workPhone">' + contactData.workPhone + '</a><a n="homePhone">' + contactData.homePhone + '</a><a n="mobilePhone">' + contactData.mobilePhone + '</a>')
    * if (!includePhoneFields) karate.set('phoneTags', '')
    # Conditionally set address tags
    * if (includeAddressFields) karate.set('addressTags', '<a n="workStreet">' + contactData.workStreet + '</a><a n="workCity">' + contactData.workCity + '</a><a n="workState">' + contactData.workState + '</a>')
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
    * url userSoapUrl
    #    * def finalRequest = karate.read('classpath:requests/createContactRequest.xml')
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
