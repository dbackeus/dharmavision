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

  describe "POST create" do
    before { sign_in user }

    context "with an existing movie" do
      it "redirects to movie with a notice" do
        movie = create :movie

        post :create, movie: { imdb_id: movie.imdb_id }

        response.should redirect_to movie_path(movie)
      end
    end
  end
end
