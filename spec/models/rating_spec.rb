require "rails_helper"

describe Rating do
  it { is_expected.to validate_presence_of(:movie) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_inclusion_of(:rating).to_allow(1..10).on(:create) }
  it { is_expected.to validate_uniqueness_of(:movie_id).scoped_to(:user_id).on(:create) }

  context "on being saved" do
    it "updates movies average rating" do
      user1 = create :user
      user2 = create :user
      movie = create :movie

      Rating.create! user: user1, movie: movie, rating: 4
      Rating.create! user: user2, movie: movie, rating: 7

      movie.reload.average_rating.should == 5.5
    end
  end
end
