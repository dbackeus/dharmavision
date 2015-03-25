require "rails_helper"

describe TmdbMovie do
  it "is an openstruct" do
    TmdbMovie.new(foo: {baz: "bar"}).foo.baz.should == "bar"
  end

  describe "#mpaa" do
    context "given a tmdb movie with a US rating" do
      it "returns the US rating" do
        attributes = JSON.parse webmock("themoviedb.org/jungle_book.json")

        movie = TmdbMovie.new(attributes)

        movie.mpaa.should == "G"
      end
    end

    context "given a tmdb movie without a US rating" do
      it "is nil" do
        attributes = JSON.parse webmock("themoviedb.org/lagaan.json")

        movie = TmdbMovie.new(attributes)

        movie.mpaa.should be_nil
      end
    end
  end
end
