Feature: Create User Account as Zimbra Admin

#Steps
# 1. Login as Admin
# 2. Create a user Account

  Background: 
#===================================================Common Configurations================================================================================
    * configure ssl = true

  @Sanity
  Scenario Outline: Create a user Account with and without zimbraForeignPrincipal
    * url adminSoapUrl
#===================================================Admin Login =======================================================================================
    * def result = call read('classpath:features/Admin-Login.feature')
    * def authToken = result.authToken
    * print authToken
#===================================================Configure Data As per Request======================================================================
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain
    # Set condition to exclude accountTag for this scenario
    * def includeAccountTag = '<includeAccountTag>'
    # Only generate time, counter, and foreignPrincipal if accountTag is needed
    * def accountTag = ''
    * if (includeAccountTag) karate.set('time', java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(java.time.LocalDateTime.now()))
    * if (includeAccountTag) karate.set('counter', java.util.concurrent.ThreadLocalRandom.current().nextInt(100, 999))
    * if (includeAccountTag) karate.set('foreignPrincipal', 'test:' + time + '.' + counter)
    * if (includeAccountTag) karate.set('accountTag', '<account by="zimbraForeignPrincipal">' + foreignPrincipal + '</account>')
    * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
    * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
    * def finalRequest = finalRequest.replace('#(email)', email)
    * def finalRequest = finalRequest.replace('#(accountTag)', accountTag)
    * print finalRequest
#===================================================Create User Account ================================================================================
    Given request finalRequest
    * configure ssl = true
    And header Content-Type = 'text/xml; charset=UTF-8'
    When method post
    Then status 200
    # Use XML path expression instead of object navigation
    * def accountId = karate.xmlPath(response, "//account/@id")
    * print 'Account ID:', accountId
     * def result = call read('classpath:features/Common-Assertions.feature@Verify_CreateAccountResponse')

    Examples: 
      | includeAccountTag |
      | True              |
      | False             |
      
      @Common_AccountCreation
  Scenario Outline: Create a user Account with zimbraForeignPrincipal
    * url adminSoapUrl
#===================================================Admin Login =======================================================================================
    * def result = call read('classpath:features/Admin-Login.feature')
    * def authToken = result.authToken
    * print authToken
#===================================================Configure Data As per Request======================================================================
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain
    # Set condition to exclude accountTag for this scenario
    * def includeAccountTag = '<includeAccountTag>'
    # Only generate time, counter, and foreignPrincipal if accountTag is needed
    * def accountTag = ''
    * if (includeAccountTag) karate.set('time', java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(java.time.LocalDateTime.now()))
    * if (includeAccountTag) karate.set('counter', java.util.concurrent.ThreadLocalRandom.current().nextInt(100, 999))
    * if (includeAccountTag) karate.set('foreignPrincipal', 'test:' + time + '.' + counter)
    * if (includeAccountTag) karate.set('accountTag', '<account by="zimbraForeignPrincipal">' + foreignPrincipal + '</account>')
    * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
    * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
    * def finalRequest = finalRequest.replace('#(email)', email)
    * def finalRequest = finalRequest.replace('#(accountTag)', accountTag)
    * print finalRequest
#===================================================Create User Account ================================================================================
    Given request finalRequest
    * configure ssl = true
    And header Content-Type = 'text/xml; charset=UTF-8'
    When method post
    Then status 200
    # Use XML path expression instead of object navigation
    * def accountId = karate.xmlPath(response, "//account/@id")
    * print 'Account ID:', accountId
     * def result = call read('classpath:features/Common-Assertions.feature@Verify_CreateAccountResponse')

    Examples: 
      | includeAccountTag  |
      | false              |
      
