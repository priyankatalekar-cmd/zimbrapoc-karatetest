̥̥Feature: Create a Contact

Background: 
* def DataFaker = Java.type('com.github.javafaker.Faker')
* def faker = new DataFaker()
* def DataGenerator = Java.type('utils.DataGenerator')
# Generate contact data
* def contactData = DataGenerator.getCompleteContactData()
* configure ssl = true

@Sanity
Scenario Outline: <testDescription>
* def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
* def authToken = result.userAuthToken
* def csfrToken = result.csfrToken

# Use flags from Examples table
* def includeExtended = <extendedFlag>
* def includePhone = <phoneFlag>
* def includeAddress = <addressFlag>
* def blankBasic = <blankBasicFields>
* def invalidData = false      
* def spaceType = '<spaceType>'

# Handle space modifications for firstName and lastName (no invalidData scenarios)
* def baseFirstName = blankBasic ? '' : contactData.firstName
* def baseLastName = blankBasic ? '' : contactData.lastName

# Apply space variations based on spaceType
* def firstName = spaceType == 'leading' ? '   ' + baseFirstName : (spaceType == 'trailing' ? baseFirstName + '   ' : baseFirstName)
* def lastName = spaceType == 'leading' ? '   ' + baseLastName : (spaceType == 'trailing' ? baseLastName + '   ' : baseLastName)

* def email = blankBasic ? '' : contactData.email
* def company = blankBasic ? '' : contactData.company

# Build tags conditionally
* karate.set('baseTags', '<a n="firstName">' + firstName + '</a><a n="lastName">' + lastName + '</a><a n="email">' + email + '</a><a n="company">' + company + '</a>')
* karate.set('extendedTags', includeExtended ? '<a n="middleName">' + contactData.middleName + '</a><a n="jobTitle">' + contactData.jobTitle + '</a>' : '')
* karate.set('phoneTags', includePhone ? '<a n="workPhone">' + contactData.workPhone + '</a><a n="mobilePhone">' + contactData.mobilePhone + '</a>' : '')
* karate.set('addressTags', includeAddress ? '<a n="workStreet">' + contactData.workStreet + '</a><a n="workCity">' + contactData.workCity + '</a>' : '')

* def soapTemplate = karate.readAsString('classpath:requests/createContactRequest.xml')
* def finalRequest = soapTemplate.replace('#(authToken)', authToken)
* def finalRequest = finalRequest.replace('#(csfrToken)', csfrToken)
* def finalRequest = finalRequest.replace('#(baseTags)', baseTags)
* def finalRequest = finalRequest.replace('#(extendedTags)', extendedTags)
* def finalRequest = finalRequest.replace('#(phoneTags)', phoneTags)
* def finalRequest = finalRequest.replace('#(addressTags)', addressTags)

* print 'Test Description:', '<testDescription>'

* url userSoapUrl
  Given request finalRequest
    And header Content-Type = 'application/soap+xml'
   When method POST
   Then status <expectedStatus>

* print 'Received status:', responseStatus
* match responseStatus == <expectedStatus>


  Examples: 
    | testDescription | extendedFlag | phoneFlag | addressFlag | blankBasicFields | useInvalidData | expectedStatus | spaceType | 
# Positive Test Cases
    | Create full contact - positive    | true  | true  | true  | false | false | 200 | normal | 
    | Create minimal contact - positive | false | false | false | false | false | 200 | normal | 
    | Create extended only - positive   | true  | false | false | false | false | 200 | normal | 
    | Create phone only - positive      | false | true  | false | false | false | 200 | normal | 

# Negative Test Cases - Blank Fields
    | Create contact with all blank basic | false | false | false | true | false | 500 | normal | 

# Edge Cases
    | Create contact with no optional fields | false | false | false | false | false | 200 | normal | 
    | Create with extended but blank basic   | true  | false | false | true  | false | 200 | normal | 

# Space Testing - Leading Spaces
    | Create contact with leading spaces | true | true | false | false | false | 200 | leading | 

# Space Testing - Trailing Spaces
    | Create contact with trailing spaces | true | true | false | false | false | 200 | trailing | 
    
    
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
Scenario Outline: Create a Contact with basic fields including fileAs tag - <testDescription>

  # Define your fileAs input here (change as needed)
  * def fileAsInput = <fileAsInput>

  # Simple client-side validation for fileAs value
 # * if (fileAsInput == -1 || fileAsInput == 10) karate.fail('Invalid fileAs input: ' + fileAsInput)

  # Existing setup and tokens
  * def Tag = 'name'
  * def includeAccountTag = 'False'
  * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
  * def authToken = result.userAuthToken
  * def csfrToken = result.csfrToken

  # Configuration flags
  * def includeExtendedFields = false
  * def includePhoneFields = false
  * def includeAddressFields = false

  # Add fileAs tag to baseTags along with other basic tags
  * karate.set('baseTags', '<a n="firstName">' + contactData.firstName + '</a>' + '<a n="lastName">' + contactData.lastName + '</a>'  + '<a n="email">' + contactData.email + '</a>' + '<a n="company">' + contactData.company + '</a>' + '<a n="fileAs">' + fileAsInput + '</a>')

  # Conditionally empty other tags as before
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

  * url userSoapUrl
  Given request finalRequest
  And header Content-Type = 'application/soap+xml'
  * configure ssl = true
  When method POST
  Then status <expectedStatus>

* print 'Received status:', responseStatus
* match responseStatus == <expectedStatus>
  
  Examples: 
  |testDescription |fileAsInput|expectedStatus|
  |Valid Input     |3          |200           |
  |Invalid Input -1|-1         |500           |
  |Invalid Input 10|10         |500           |
  


