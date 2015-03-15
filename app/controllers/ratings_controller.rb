class RatingsController < ApplicationController
  def create
    movie = Movie.find(rating_params[:movie_id])

    rating = movie.ratings.find_or_initialize_by(user: current_user)
    rating.rating = rating_params[:rating]

    if rating.save
      head :no_content
    else
      render json: rating.errors, status: :unprocessable_entity
    end
  end

  private

  def rating_params
    params.require(:rating)
  end
end
