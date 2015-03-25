require "rails_helper"

describe Movie do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :imdb_id }
  it { is_expected.to validate_presence_of :creator }
  it { is_expected.to validate_uniqueness_of :imdb_id }

  specify { Movie.new.average_rating.should == 0.0 }
  specify { Movie.new.ratings_count.should == 0 }

  describe "#mpaa_rating" do
    it "gets the rating without explanation" do
      {
        "G" => "Rated G bla bla",
        "PG" => "Rated PG for sci-fi violence and brief mild language",
        "PG-13" => "Rated PG-13 for sci-fi action violence",
        "R" => "Rated R for language and prison violence (certificate 33087)",
        "NC-17" => "Rated NC-17 for explicit sexual content and graphic nudity throughout",
      }.each do |actual, description|
        Movie.new(mpaa: description).mpaa_rating.should == actual
      end
    end

    it "returns nil unless rating is available" do
      Movie.new.mpaa_rating.should be_nil
    end
  end

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

  describe "#poster_url" do
    it "generates url from tmdb poster path and given size" do
      movie = Movie.new
      movie.poster_url.should be_nil

      movie.tmdb_poster_path = "/foo.jpg"
      movie.poster_url.should == "https://image.tmdb.org/t/p/w500/foo.jpg"
      movie.poster_url("w92").should == "https://image.tmdb.org/t/p/w92/foo.jpg"
    end
  end

  context "being created" do
    it "validates imdb ids to exist on imdb" do
      stub_request(:get, "http://akas.imdb.com/title/tt234169102/combined").
        to_return(status: 404)

      movie = Movie.new(imdb_id: "0169102")
      movie.save

      movie.errors[:imdb_id].should_not include "needs to be a valid imdb id or url"

      movie = Movie.new(imdb_id: "234169102")
      movie.save

      movie.errors[:imdb_id].should include "needs to be a valid imdb id or url"
    end

    it "assigns metadata from imdb" do
      movie = create :movie, imdb_id: "0169102"

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

    it "assigns metadata from tmdb" do
      movie = create :movie, imdb_id: "0169102"

      movie.tmdb_id.should == 19666
      movie.tmdb_poster_path.should == "/iXpV2SCApjhLDvn9Usmk4hiQe4J.jpg"
      movie.tmdb_backdrop_path.should == "/x0si3I9JKup9t6l88MF6S3lZ3Cd.jpg"
    end

    context "with an imdb movie without plot info" do
      it "sets plot from tmdb" do
        stub_request(:get, "http://akas.imdb.com/title/tt0158914/combined").
          to_return(body: webmock("imdb.com/dyaneshwar.html"))

        stub_request(:get, "http://akas.imdb.com/title/tt0158914/releaseinfo").
          to_return(body: webmock("imdb.com/dyaneshwar_releaseinfo.html"))

        stub_request(:get, "http://api.themoviedb.org/3/find/tt0158914?api_key=themoviedb_api_key&external_source=imdb_id").
          to_return(body: webmock("themoviedb.org/find_dyaneshwar.json"))

        stub_request(:get, "http://api.themoviedb.org/3/movie/257396?api_key=themoviedb_api_key&append_to_response=alternative_titles").
          to_return(body: webmock("themoviedb.org/dyaneshwar.json"))

        movie = create :movie, imdb_id: "0158914"

        movie.plot.should == "It's the story of a boy who finds enlightenment by experiencing religious hipocrisy and dogmatism. Dnyaneshwar liberated the \"divine knowledge\" locked in the Sanskrit language to bring that knowledge into Prakrit (Marathi) and made it available to the common man."
      end
    end
  end
end
