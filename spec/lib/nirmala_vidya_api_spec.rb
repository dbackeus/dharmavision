require "rails_helper"

describe NirmalaVidyaApi do
  describe ".authenticate" do
    it "returns the json response" do
      stub_request(:post, "http://test2.nirmalavidyaportal.org/authenticate").
        with(:body => {"password"=>"password", "username"=>"username"}).
        to_return(body: webmock("nirmalavidya.org/authenticate.json"))

      result = NirmalaVidyaApi.authenticate("username", "password")

      result.should eq(
        "status" => "y",
        "id" => "974",
        "email" => "foo@bar.com",
        "name" => "Simon Band",
        "yogi_access" => "Yes",
      )
    end
  end
end
