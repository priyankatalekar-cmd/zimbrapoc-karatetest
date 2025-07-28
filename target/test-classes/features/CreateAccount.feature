Feature: Send Email from one account to another using SOAP API

  Background: 
    * url adminSoapUrl
    * configure ssl = true
    

  Scenario: Inject foreignPrincipal dynamically in XML request
    * def result = call read('classpath:features/Login.feature')
    * def authToken = result.authToken
    * print authToken
    * def randomId = java.util.UUID.randomUUID().toString().substring(0, 8)
    * def username = 'qauser_' + randomId
    * def domain = 'qa-u56-singlenode-ps.eng.zimbra.com'
    * def email = username + '@' + domain
    
    # * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
    * def time = java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(java.time.LocalDateTime.now())
    * def counter = java.util.concurrent.ThreadLocalRandom.current().nextInt(100, 999)
    * def foreignPrincipal = 'test:' + time + '.' + counter
    * def accountTag = '<account by="zimbraForeignPrincipal">' + foreignPrincipal + '</account>'
    
    * def soapTemplate = karate.readAsString('classpath:requests/createAccountRequest.xml')
    * def finalRequest = soapTemplate.replace('#(authToken)', authToken)
    * def finalRequest = finalRequest.replace('#(email)', email)
    * def finalRequest = finalRequest.replace('#(accountTag)', accountTag)
    * print finalRequest
    
    Given request finalRequest
    * configure ssl = true
    And header Content-Type = 'text/xml; charset=UTF-8'
    When method post
    Then status 200
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # ✅ Correct replacement method
 # * def finalRequest = karate.template(soapTemplate, replacements)
  #* print finalRequest
