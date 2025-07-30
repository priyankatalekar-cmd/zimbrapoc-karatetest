Feature: Briefcase- Upload a File

  Background: 
    * configure ssl = true
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    * def result = karate.call('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = result.userAuthToken
    * def csfrToken = result.csfrToken

  #  * def includeAccountTag = karate.get('includeAccountTag', false)
  #  * def result = call read('classpath:features/CreateAccount.feature')

  Scenario Outline: Briefcase- Upload a File
    ############################ getFolderRequest #########################################################
    * url userSoapUrl
    * def env = karate.read('classpath:requests/getFolderRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def briefcaseId = karate.xmlPath(response, "//*[local-name()='folder' and @name='Briefcase']/@id")
    * print 'Briefcase ID:', briefcaseId
    
      ############################ Upload a File #########################################################
    * url 'https://80.225.207.85:443/service/upload?fmt=raw'
    And header X-Zimbra-Csrf-Token = csfrToken
    And header Cookie = 'ZM_AUTH_TOKEN=' + authToken
    And header User-Agent = 'Jakarta Commons-HttpClient/3.1'
    And multipart file file = { read: 'classpath:testData/<fileName>', filename: '<fileName>', contentType: 'application/json' }
    When method POST
    Then status 200
    * def aid = response.match(/200,'null','([^']+)'/)[1]
    * print 'Uploaded file:', '<fileName>', 'Attachment ID:', aid
    ############################ Save the Document #########################################################
    * def briefcaseId =  briefcaseId
    * def uploadAid =  aid
    * url userSoapUrl
    * def env = karate.read('classpath:requests/saveDocumentRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def docId = karate.xmlPath(response, "//*[local-name()='SaveDocumentResponse']/*[local-name()='doc']/@id")
    * print 'Saved Document ID:', docId
    * match docId != ' '

    Examples: 
      | fileName           |
      | defaultConfig.json |
