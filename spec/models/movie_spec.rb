require "rails_helper"

describe Movie do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :imdb_id }
  it { is_expected.to validate_presence_of :creator }
  it { is_expected.to validate_uniqueness_of :imdb_id }

  specify { Movie.new.average_rating.should == 0.0 }
  specify { Movie.new.ratings_count.should == 0 }

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

    it "assigns metadata from rotten tomatoes" do
      movie = create :movie, imdb_id: "0169102"

      movie.rotten_id.should == 10306
      movie.rotten_poster.should == "https://resizing.flixster.com/3Cm7uazgitpnDsbB9jAjwfddpeU=/54x78/dkpu1ddg7pbsk.cloudfront.net/movie/10/87/07/10870712_ori.jpg"
    end

    context "when movie doesn't exist on rotten tomatoes" do
      it "doesn't set any metadata" do
        stub_request(:get, "http://api.rottentomatoes.com/api/public/v1.0/movie_alias.json?apikey=rotten_tomatoes_api_key&id=0169102&type=imdb").
          to_return(body: { "error" => "Could not find a movie with the specified id" }.to_json)

        movie = create :movie, imdb_id: "0169102"

        movie.rotten_id.should be_nil
      end
    end

    it "assigns metadata from omdb" do
      movie = create :movie, imdb_id: "0169102"

      movie.omdb_poster.should == "http://ia.media-imdb.com/images/M/MV5BMTIwODMwMzA5Ml5BMl5BanBnXkFtZTcwMTQxNTEyMQ@@._V1_SX300.jpg"
      movie.omdb_plot.should == "This is the story about the resilience shown by the Indians when they were under the British Rule. They are already taxed to the bone by the British and their cronies, but when Jack Russell announces that he will double the Lagaan (tax) from all villagers, they decide to oppose it. Leading the villagers is a handsome young man named Bhuvan, who challenges them to a game of cricket, a game that is to be played by veteran British cricket players, versus villagers, including Bhuvan himself, who have never played this game before, and do not even know a bat from a piece of wood. As the challenge is accepted, the interest grows and attracts Indians from all over the region, as well as the British from all over the country - as everyone gathers to see the 'fair play' that the British will display against their counter-parts, who are aided by none other than the sister, Elizabeth, of Captain Rusell."
    end

    it "assigns metadata from tmdb" do
      movie = create :movie, imdb_id: "0169102"

      movie.tmdb_id.should == 19666
      movie.tmdb_poster_path.should == "/iXpV2SCApjhLDvn9Usmk4hiQe4J.jpg"
      movie.tmdb_backdrop_path.should == "/x0si3I9JKup9t6l88MF6S3lZ3Cd.jpg"
    end
  end
end
