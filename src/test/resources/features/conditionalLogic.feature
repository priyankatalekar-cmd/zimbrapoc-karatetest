Feature: Zimbra Contact Creation - Sanity Tests

Background:
  * url userSoapUrl
  * configure ssl = true
  * def result = call read('classpath:features/UserLogin.feature')
  * def authToken = result.userAuthToken
  * def csrfToken = result.csfrToken

@sanity
Scenario: Create Contact - Simple Working Version
  * def timestamp = java.lang.System.currentTimeMillis()
  
  # Build contact XML as a simple string - NO FUNCTIONS
  * def firstName = 'Contact' + timestamp
  * def lastName = 'User' + timestamp
  * def email = 'test' + timestamp + '@domain.com'
  * def contactXml = '<a n="firstName">' + firstName + '</a><a n="lastName">' + lastName + '</a><a n="email">' + email + '</a>'
  
  # Debug - verify what we're sending
  * print 'Contact XML:', contactXml
  
  # Send request
  And request read('classpath:requests/createContactDynamic.xml')
  When method post
  Then status 200
  * def contactId = /soap:Envelope/soap:Body/CreateContactResponse/cn/@id
  * print 'SUCCESS! Contact created with ID:', contactId

@sanity  
Scenario: Create Contact - With Company
  * def timestamp = java.lang.System.currentTimeMillis()
  * def contactXml = '<a n="firstName">Business' + timestamp + '</a><a n="lastName">Contact</a><a n="email">biz' + timestamp + '@company.com</a><a n="company">ACME Corp</a>'
  
  And request read('classpath:requests/createContactDynamic.xml')
  When method post
  Then status 200
  * print 'SUCCESS! Business contact created'
  