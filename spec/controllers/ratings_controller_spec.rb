require "rails_helper"

describe RatingsController do
  let(:user) { create :user }

  before { sign_in user }

  describe "POST create" do
    let(:movie) { create :movie }

    context "with valid params" do
      before do
        post :create, rating: { movie_id: movie.id.to_s, rating: 5 }
      end

      it "creates the rating" do
        rating = Rating.find_by(movie_id: movie.id, user_id: user.id)

        rating.rating.should == 5
      end

      it "returns 204 created" do
        response.should have_http_status(:no_content)
      end
    end

    context "with invalid params" do
      before do
        post :create, rating: { movie_id: movie.id.to_s, rating: 100 }
      end

       it "responds with unprocessable entity" do
         response.should have_http_status(:unprocessable_entity)
       end

       it "responds with an error json" do
         JSON.parse(response.body)["rating"].should include "is not included in the list"
       end
    end

    context "with an already existing rating" do
      it "updates the rating" do
        rating = Rating.create!(movie: movie, user: user, rating: 5)

        post :create, rating: { movie_id: movie.id.to_s, rating: 10 }

        rating.reload.rating.should == 10
      end
    end
  end
end
