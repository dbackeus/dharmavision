require "rails_helper"

describe MoviesController do
  let(:user) { create :user }

  describe "GET show" do
    let(:movie) { create :movie }

    context "signed in" do
      before { sign_in user }

      it "renders successfully" do
        get :show, id: movie.id

        response.should have_http_status(200)
      end
    end

    context "not signed in" do
      it "renders successfully" do
        get :show, id: movie.id

        response.should have_http_status(200)
      end
    end

    context "as json" do
      it "renders json" do
        get :show, format: :json, id: movie.id

        response.should have_http_status(200)

        JSON.parse(response.body)["id"].should == movie.id.to_s
      end
    end
  end

  describe "GET search.json" do
    it "returns elastic search results" do
      Movie.reindex

      movie = create :movie
      Movie.searchkick_index.refresh

      get :search, format: :json, query: "lagaan"

      json = JSON.parse(response.body)

      json.first["id"].should == movie.id.to_s
    end
  end

  describe "POST create" do
    before { sign_in user }

    context "with valid params" do
      before do
        post :create, movie: { imdb_id: "0169102" }
      end

      it "creates the movie with reference to creator" do
        Movie.find_by(imdb_id: "0169102").creator.should == subject.current_user
      end

      it "redirects to movie with a notice" do
        movie = Movie.find_by(imdb_id: "0169102")

        response.should redirect_to movie_path(movie)
        flash[:notice].should be_present
      end
    end

    context "with an existing movie" do
      it "redirects to movie with a notice" do
        movie = create :movie

        post :create, movie: { imdb_id: movie.imdb_id }

        response.should redirect_to movie_path(movie)
        flash[:notice].should be_present
      end
    end
  end
end
