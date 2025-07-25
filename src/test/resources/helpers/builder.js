function fn() {
  function buildEmailPayload(data) {
    var payload = {
      authToken: data.authToken,
      csrfToken: data.csrfToken,
      subject: data.subject || null,
      to: data.to || null,
      contentType: data.contentType || 'text/plain',
      body: data.body || ''
    };
    return payload;
  }

  return { buildEmailPayload: buildEmailPayload };
}
