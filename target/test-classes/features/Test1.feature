Feature: Create Zimbra Appointment

  Background: 
    * def result = call read('classpath:features/UserLogin.feature')
    * def authToken = result.userAuthToken
    * print authToken
    * def csrfToken = result.csfrToken
    * print csrfToken
    * def env = karate.read('classpath:requests/soap-envelope.xml')
    * def XmlTemplateProcessor = Java.type('utils.XmlTemplateProcessor')

  Scenario: Create appointment using XML template
    # Define appointment data
    * def appointment = { subject: "Team Meeting", location: "Conference Room A", content: "Discuss project updates" }
    * def attendee = "attendee@example.com"
    * def organizer = "organizer@example.com"
    * def startTime = "20250725T100000Z"
    * def endTime = "20250725T110000Z"
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
