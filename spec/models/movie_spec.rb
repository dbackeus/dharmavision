require "rails_helper"

describe Movie do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :imdb_id }
  it { is_expected.to validate_uniqueness_of :imdb_id }

  specify { Movie.new.average_rating.should == 0.0 }

  describe "#imdb_id=" do
    it "parses the imdb id from imdb urls if given a url" do
      Movie.new(imdb_id: "0169102").imdb_id.should == "0169102"
      Movie.new(imdb_id: "http://www.imdb.com/title/tt0169102/").imdb_id.should == "0169102"
    end
  end

  describe "#serializable_hash" do
    it "replaces _id with id as string" do
      movie = Movie.new(id: oid)

      movie.serializable_hash.should include id: oid.to_s
      movie.serializable_hash.has_key?(:_id).should == false
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

    it "assigns metadata from imdb" do
      movie = Movie.create!(imdb_id: "0169102")

      movie.title.should == "Lagaan: Once Upon a Time in India"
      movie.plot.should == "The people of a small village in Victorian India stake their future on a game of cricket against their ruthless British rulers..."
      movie.year.should == 2001
      movie.mpaa.should == "Rated PG for language and some violence"
      movie.titles.to_json.should == [
        MovieTitle.new(version: "(original title)", title: "Lagaan: Once Upon a Time in India"),
        MovieTitle.new(version: "Argentina", title: "Lagaan: Érase una vez en la India"),
        MovieTitle.new(version: "Brazil", title: "Lagaan - Era Uma Vez Na Índia"),
        MovieTitle.new(version: "Germany", title: "Lagaan - Es war einmal in Indien"),
        MovieTitle.new(version: "Spain", title: "Lagaan: Érase una vez en la India"),
        MovieTitle.new(version: "Finland", title: "Lagaan - olipa kerran Intiassa"),
        MovieTitle.new(version: "France", title: "Lagaan"),
        MovieTitle.new(version: "Greece (DVD title)", title: "Lagaan"),
        MovieTitle.new(version: "Hungary", title: "Lagaan"),
        MovieTitle.new(version: "India (Hindi title) (short title)", title: "Lagaan"),
        MovieTitle.new(version: "Poland", title: "Lagaan: Dawno temu w Indiach"),
        MovieTitle.new(version: "Portugal", title: "Lagaan - Era Uma Vez na Índia"),
        MovieTitle.new(version: "Serbia", title: "Lagan: Bilo jednom u Indiji"),
        MovieTitle.new(version: "Russia", title: "Лагаан: Однажды в Индии"),
        MovieTitle.new(version: "Sweden", title: "Lagaan"),
        MovieTitle.new(version: "Sweden (DVD title)", title: "Lagaan - Det var en gång i Indien"),
        MovieTitle.new(version: "World-wide (English title) (informal literal title)", title: "Land Tax"),
      ].to_json
    end
  end
end
