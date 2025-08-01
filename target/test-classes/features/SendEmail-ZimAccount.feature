Feature: Send Email from one Account to Another Account using SOAP API

  Background: 
    * url userSoapUrl
    * def createResponse = call read('classpath:features/Create-User-Accounts.feature@Common_AccountCreation')
    * def test_account1 = createResponse.email
    * print test_account1
    * def createResponse = call read('classpath:features/Create-User-Accounts.feature@Common_AccountCreation')
    * def test_account2 = createResponse.email
    * print test_account2
    * def createResponse = call read('classpath:features/Create-User-Accounts.feature@Common_AccountCreation')
    * def test_account3 = createResponse.email
    * print test_account3
    * def subject = "Random Subject to Generate"
    * def content = "This is Test mail from karate"

  @SmokeTest1
  Scenario: Send Email from one Account to Another Account using SOAP API and Verify User Received Successfully
    #============================================ userLogin Sender =================================================================================
    * def password = 'Welcome123'
    * def authType = 'name'
    * def accountValue = test_account1
    * def env = karate.read('classpath:requests/authRequestUser.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def authToken = karate.xmlPath(response, '//authToken')
    * print 'Auth Token is:', authToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken
    #===================================== getFolderRequest ===============================================================================================
    * def env = karate.read('classpath:requests/getFolderRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    #====================================== sendMessageRequest =============================================================================================
    * def env = karate.read('classpath:requests/sendMessageRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    # Extract the mid (message id) attribute from the <m> element inside SendMsgResponse
    * def mid = karate.xmlPath(response, "//*[local-name()='SendMsgResponse']/*[local-name()='m']/@id")
    * print 'Message ID (mid):', mid
    # Assert that mid is not null or empty (exists)
    * match mid != null
    * match mid != ''
    #====================================== userLogin Receiver =============================================================================================
    #* def username = 'qauser_892c0c26@qa-u56-singlenode-ps.eng.zimbra.com'
    * def password = 'Welcome123'
    * def authType = 'name'
    * def accountValue = test_account2
    * def env = karate.read('classpath:requests/authRequestUser.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def authToken = karate.xmlPath(response, '//authToken')
    * print 'Auth Token is:', authToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken
    #=========================================== searchInboxReceiver ======================================================================================
    * def searchQuery = 'random'
    * def typeValue = 'conversation'
    * def env = karate.read('classpath:requests/searchRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def messageId = karate.xmlPath(response, '//m/@id')
    * print 'Receiver got message with ID:', messageId
    * match messageId != null
