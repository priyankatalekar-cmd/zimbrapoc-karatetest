Feature: Create Zimbra Appointment using karate.read()

  Background: 
    * url userSoapUrl
    * def username = 'xyz2313490priyankatalekar5@qa-u56-singlenode-ps.eng.zimbra.com'
    * def password = 'Welcome123'
    * configure ssl = true
    
    # Step 1: Authenticate user and extract tokens
    * def authType = 'name'
    * def accountValue = username
    * def loginRequest = read('classpath:requests/authRequestUser.xml')
    Given request loginRequest
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    * def userAuthToken = karate.xmlPath(response, '//authToken')
    * print 'Auth Token is:', userAuthToken
    * def csfrToken = karate.xmlPath(response,'//csrfToken')
    * print 'csrfToken is:', csfrToken
    * def authToken = userAuthToken
    * def csrfToken = csfrToken
    
    # Step 2: Setup dynamic appointment parameters
    * def test_account1 = username
    * def test_account2 = 'qauser_f8b093fa@qa-u56-singlenode-ps.eng.zimbra.com'
    * def appointment =
      """
      {
        subject: 'SOAP Appointment Subject',
        location: 'Room 101',
        content: 'This is the appointment content'
      }

      """
    * def organizer = test_account1
    * def attendee = test_account2
    * def startTime = '20250723T080000Z'
    * def endTime = '20250723T083000Z'
    
    
    # Step 3: Read SOAP body with #(...) variable substitution
    * def requestBody = read('classpath:requests/createAppointmentRequest.xml')

		# Step 4: Call the API 
		@Sanity
  	Scenario: Create appointment with auth and test accounts
    Given request requestBody
    And header Content-Type = 'application/soap+xml'
    When method POST
    Then status 200
    And match response /Envelope/Body/CreateAppointmentResponse != null
