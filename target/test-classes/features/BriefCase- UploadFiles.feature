Feature: Briefcase- Upload a File

  Background: 
    #===================================================Common Configurations================================================================================
    * configure ssl = true
    * def Tag = 'name'
    * def includeAccountTag = 'False'
    * def loginResponse = call read('classpath:features/Auth-Basic.feature@Common_Login')
    * def authToken = loginResponse.authToken
    * def csfrToken = loginResponse.csfrToken

  #  * def includeAccountTag = karate.get('includeAccountTag', false)
  #  * def result = call read('classpath:features/CreateAccount.feature')
  Scenario Outline: Briefcase- Upload a File <testDescription>
    #============================================================= getFolderRequest==========================================================================
    * url userSoapUrl
    * def env = karate.read('classpath:requests/getFolderRequest.xml')
    Given request env
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
    * def briefcaseId = karate.xmlPath(response, "//*[local-name()='folder' and @name='Briefcase']/@id")
    * print 'Briefcase ID:', briefcaseId
    #==========================================================Assertions ====================================================================================
    * match briefcaseId != null
    * match briefcaseId != ''
    #=============================================================== Upload a File ============================================================================
    * url 'https://80.225.207.85:443/service/upload?fmt=raw'
    And header X-Zimbra-Csrf-Token = csfrToken
    And header Cookie = 'ZM_AUTH_TOKEN=' + authToken
    And header User-Agent = 'Jakarta Commons-HttpClient/3.1'
    And multipart file file = { read: 'classpath:testData/<fileName>', filename: '<fileName>', contentType: 'application/json' }
    When method POST
    Then status 200
    * def aid = response.match(/200,'null','([^']+)'/)[1]
    * print 'Uploaded file:', '<fileName>', 'Attachment ID:', aid
    #==========================================================Assertions==================================================================================
    * match aid != null
    * match aid != ''
    #================================================================Save the Document=====================================================================
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
    #===========================================================Assertions==================================================================================
    * match docId != null
    * match docId != ''
    * assert docId.length > 0
    #================================================================Search the Document=========================================================================
    * def searchQuery = '<fileName>'
    * def typeValue = 'document'
    * def soaprequest = karate.read('classpath:requests/searchRequest.xml')
    Given request soaprequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    #=========================================================Assertions======================================================================================
    * def actualfileName = karate.xmlPath(response, "//*[local-name()='SearchResponse']/*[local-name()='doc']/@name")
    * print actualfileName
    * match actualfileName == '<fileName>'

    Examples: 
      | fileName               | testDescription |
      | defaultConfig.json     | JSON            |
      | Screenshot.png         | PNG             |
      | Word.docx              | Word            |
      | TextFile.txt           | Text            |
      | xml_request_values.pdf | PDF             |
