require "rails_helper"

describe ImdbController do
  describe "GET search" do
    it "searches imdb" do
      stub_request(:get, "http://akas.imdb.com/find?q=spirited%20away%3Bs=tt").
        to_return(body: webmock("spirited_away_search.html"))

      get :search, query: "spirited away"

      json_response = JSON.parse(response.body)

      json_response.should include(
        "id" => "0245429",
        "url"=>"http://akas.imdb.com/title/tt0245429/combined",
        "title" => "Spirited Away (2001)",
      )

      json_response.length.should == 10
    end
  end
end
