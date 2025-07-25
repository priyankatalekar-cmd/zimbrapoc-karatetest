function fn() {
  var config = {
    // Base URLs
    userSoapUrl: 'https://80.225.207.85/service/soap/',
    adminSoapUrl: 'https://80.225.207.85:9071/service/admin/soap/',
    usersFile: 'file:./data/users.csv'
  };

  // Read user count from Maven/Jenkins (or default to 5)
  var userCount = karate.properties['karate.userCount'] || 5;
  config.userCount = parseInt(userCount);
  karate.log('🔢 Users to create:', config.userCount);

  // Utility to create random email
  	config.randomEmail = function(prefix) {
    var id = java.util.UUID.randomUUID().toString().substring(0, 8);
    return prefix + '_' + id + '@zimbra.test';
  };

  return config;
}

