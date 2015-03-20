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
end
