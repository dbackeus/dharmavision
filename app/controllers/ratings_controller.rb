class RatingsController < ApplicationController
  # Note: Sending rating 0 will remove rating
  def create
    rating_params = params.require(:rating)
    movie = Movie.find(rating_params[:movie_id])

    rating = movie.ratings.find_or_initialize_by(user: current_user)
    rating.rating = rating_params[:rating]

    if rating.rating == 0
      rating.destroy
    else
      rating.save! # we're assuming client only sends valid ratings
    end

    head :no_content
  end
end
