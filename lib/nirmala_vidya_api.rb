class NirmalaVidyaApi
  AUTHENTICATE_URL = "http://test2.nirmalavidyaportal.org/authenticate".freeze

  def self.authenticate(username, password)
    result = RestClient.post(AUTHENTICATE_URL, username: username, password: password)

    JSON.parse(result)
  end
end
