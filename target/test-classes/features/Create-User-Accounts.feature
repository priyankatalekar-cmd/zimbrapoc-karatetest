Feature: Create User Account as Zimbra Admin

#Steps
# 1. Login as Admin
# 2. Create a user Account

  Background: 
#===================================================Common Configurations================================================================================
    * configure ssl = true
    
@Common_AccountCreation
Scenario: Create a user Account without zimbraForeignPrincipal
  # Expect these variables to be passed in: adminSoapUrl, authToken, email

  * url adminSoapUrl
  
  # Admin Login
    * def result = call read('classpath:features/Admin-Login.feature')
    * def authToken = result.authToken
    * print 'Admin Auth Token:', authToken

    # Generate dynamic user info
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain

  # Prepare the SOAP Create Account request without accountTag
  * def accountTag = '' 
  * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
  * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
  * def finalRequest = finalRequest.replace('#(email)', email)
  * def finalRequest = finalRequest.replace('#(accountTag)', accountTag)

  * print 'Create Account SOAP Request:\n', finalRequest

  Given request finalRequest
  * configure ssl = true
  And header Content-Type = 'text/xml; charset=UTF-8'
  When method post
  Then status 200

  # Assert account creation success
  * def accountId = karate.xmlPath(response, "//account/@id")
  * print 'Created Account ID:', accountId
  * match accountId != null
  * match accountId != ''

  * def accountName = karate.xmlPath(response, "//account/@name")
  * match accountName == email
     
@zimbraForeignPrincipal
Scenario Outline: Create a user Account with zimbraForeignPrincipal
    * url adminSoapUrl

    # Admin Login
    * def result = call read('classpath:features/Admin-Login.feature')
    * def authToken = result.authToken
    * print 'Admin Auth Token:', authToken

    # Generate dynamic user info
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain

    # Normalize the tag value for easy comparison
    * def incTag = includeAccountTag == true || (typeof includeAccountTag === 'string' && includeAccountTag.toLowerCase() == 'true')

    # Only generate and add accountTag block if includeAccountTag is true
    * def accountTag = ''
    * if (incTag) karate.set('time', java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(java.time.LocalDateTime.now()))
    * if (incTag) karate.set('counter', java.util.concurrent.ThreadLocalRandom.current().nextInt(100, 999))
    * if (incTag) karate.set('foreignPrincipal', 'test:' + time + '.' + counter)
    * if (incTag) karate.set('accountTag', '<account by="zimbraForeignPrincipal">' + foreignPrincipal + '</account>')

    * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
    * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
    * def finalRequest = finalRequest.replace('#(email)', email)
    * def finalRequest = finalRequest.replace('#(accountTag)', accountTag)
    * print 'Create Account SOAP Request:', finalRequest

    # Create User Account
    Given request finalRequest
    * configure ssl = true
    And header Content-Type = 'text/xml; charset=UTF-8'
    When method post
    Then status 200

    # Assertions
    * def accountId = karate.xmlPath(response, "//account/@id")
    * print 'Account ID:', accountId
    * match accountId != null
    * match accountId != ''
    * def returnedName = karate.xmlPath(response, "//account/@name")
    * match returnedName == email

Examples: 
  | includeAccountTag  |
  | true               |
  | false              |
