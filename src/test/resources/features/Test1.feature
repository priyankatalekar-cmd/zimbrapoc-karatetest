Feature: Create Zimbra Appointment

  Background: 
    * url userSoapUrl
    * def result = call read('classpath:features/UserLogin.feature')
    * def authToken = result.userAuthToken
    * print authToken
    * def csrfToken = result.csfrToken
    * print csrfToken
    * def username = result.username
    * def env = karate.read('classpath:requests/soap-envelope.xml')
    * def XmlTemplateProcessor = Java.type('utils.XmlTemplateProcessor')

  Scenario: Create appointment using XML template
    # Define appointment data
    * def appointment = { subject: "Team Meeting", location: "Conference Room A", content: "Discuss project updates" }
    * def attendee = "qauser_f8b093fa@qa-u56-singlenode-ps.eng.zimbra.com"
    * def organizer = username
    * def startTime = java.time.ZonedDateTime.now(java.time.ZoneOffset.UTC).withHour(10).withMinute(0).withSecond(0).withNano(0).format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'"))
    * def endTime = java.time.ZonedDateTime.now(java.time.ZoneOffset.UTC).withHour(11).withMinute(0).withSecond(0).withNano(0).format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'"))
    # Define appointment request body
    * text appointmentBodyRaw =
      """
      <CreateAppointmentRequest xmlns="urn:zimbraMail">
        <m>
          <inv method="REQUEST" type="event" fb="B" transp="O" allDay="0"
               name="SUBJECT_VALUE" loc="LOCATION_VALUE">
            <at role="OPT" ptst="NE" rsvp="1" a="ATTENDEE_VALUE"/>
            <s d="START_TIME_VALUE"/>
            <e d="END_TIME_VALUE"/>
            <or a="ORGANIZER_VALUE"/>
          </inv>
          <e a="ATTENDEE_VALUE" t="t"/>
          <mp content-type="text/plain">
            <content>CONTENT_VALUE</content>
          </mp>
          <su>SUBJECT_VALUE</su>
        </m>
      </CreateAppointmentRequest>
      """
    * def processedBody = appointmentBodyRaw.replaceAll('SUBJECT_VALUE', appointment.subject).replaceAll('LOCATION_VALUE', appointment.location).replaceAll('CONTENT_VALUE', appointment.content).replaceAll('ATTENDEE_VALUE', attendee).replaceAll('ORGANIZER_VALUE', organizer).replaceAll('START_TIME_VALUE', startTime).replaceAll('END_TIME_VALUE', endTime)
    # Process template to create final SOAP request
    * def soapEnvelope = XmlTemplateProcessor.processTemplate('src/test/resources/requests/soap-envelope.xml', processedBody)
    * def finalSoapRequest = soapEnvelope.replace('#(authToken)', authToken).replace('#(csrfToken)', csrfToken)
    * print 'Final SOAP Request:', finalSoapRequest
    Given request finalSoapRequest
    And header Content-Type = 'application/soap+xml'
    * configure ssl = true
    When method POST
    Then status 200
