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
    @movie = Movie.new movie_params.merge(creator: current_user)

    if @movie.save
      redirect_to @movie, notice: "Movie was successfully created. Don't forget to add your rating!"
    elsif @movie.errors[:imdb_id].include?("is already taken")
      existing_movie = Movie.find_by(imdb_id: @movie.imdb_id)
      redirect_to movie_path(existing_movie), notice: "The movie had already been added, here it is..."
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
