class RatingsController < ApplicationController
  def create
    rating_params = params.require(:rating)
    movie = Movie.find(rating_params[:movie_id])

    rating = movie.ratings.find_or_initialize_by(user: current_user)
    rating.rating = rating_params[:rating]
    rating.save! # we're assuming client only sends valid ratings

    head :no_content
  end
end
