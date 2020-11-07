require "rails_helper"

describe TmdbController do
  describe "GET search" do
    pending "searches tmdb" do
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
