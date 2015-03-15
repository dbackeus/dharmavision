require "rails_helper"

describe Movie do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :imdb_id }
  it { is_expected.to validate_uniqueness_of :imdb_id }

  describe "#imdb_id=" do
    it "parses the imdb id from imdb urls if given a url" do
      Movie.new(imdb_id: "0169102").imdb_id.should == "0169102"
      Movie.new(imdb_id: "http://www.imdb.com/title/tt0169102/").imdb_id.should == "0169102"
    end
  end

  context "being created" do
    it "validates imdb ids to exist on imdb" do
      stub_request(:get, "http://akas.imdb.com/title/tt234169102/combined").
        to_return(status: 404)

      movie = Movie.new(imdb_id: "0169102")
      movie.save

      movie.errors[:imdb_id].should_not include "needs to be a valid url"

      movie = Movie.new(imdb_id: "234169102")
      movie.save

      movie.errors[:imdb_id].should include "needs to be a valid url"
    end

    it "assigns title from imdb" do
      movie = Movie.create!(imdb_id: "0169102")
      movie.title.should == "Lagaan: Once Upon a Time in India"
      movie.plot.should == "The people of a small village in Victorian India stake their future on a game of cricket against their ruthless British rulers..."
      movie.year.should == 2001
      movie.mpaa.should == "Rated PG for language and some violence"
    end
  end
end
