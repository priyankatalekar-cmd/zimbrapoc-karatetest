Feature: Send Email from one account to another using SOAP API

  Background: 
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain
    * url adminSoapUrl
    * def result = call read('classpath:zimbraapisuite/Login.feature')
    * def authToken = result.authToken

@CreateAccount
  Scenario: Create Account - Admin
    * def env = karate.read('classpath:requests/createAccountRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * print response
    * def raw = karate.prettyXml(response)
    * def regex = java.util.regex.Pattern.compile("name=\"([^\"]+)\"")
    * def matcher = regex.matcher(raw)
    * def emailId = matcher.find() ? matcher.group(1) : null
    * print '✅ Extracted email ID:', emailId
    
    # Save to Excel
    * eval Java.type('Utils.StoreEmailList').writeEmail(emailId)
