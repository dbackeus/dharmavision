class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]

  def index
    @movies = Movie.all.order_by(average_rating: :desc)
  end

  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @movie }
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: "Movie was successfully created."
    else
      render :new
    end
  end

  def destroy
    raise "no way" unless current_user.admin?

    @movie = Movie.find(params[:id])

    @movie.destroy

    redirect_to movies_url, notice: "Movie was successfully destroyed."
  end

  private

  def movie_params
    params.require(:movie).permit(:imdb_id)
  end

  def user_rating
    @user_rating ||= current_user.ratings.where(movie: @movie).first || @movie.ratings.build
  end
  helper_method :user_rating
end
