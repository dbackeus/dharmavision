class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]

  def index
    @movies = Movie.listed.order(average_rating: :desc, ratings_count: :desc)
  end

  def suggested
    @movies = Movie.suggested.order_by(ratings_count: :desc)
  end

  def search
    @results = Movie.search(params[:query], fields: [{"title^100" => :word_start}, :titles], limit: 10)
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
    tmdb_id = params.require(:movie).require(:tmdb_id)
    @movie = Movie.find_or_initialize_by(tmdb_id: tmdb_id)

    if @movie.persisted?
      return redirect_to movie_path(existing_movie), notice: "The movie had already been added, here it is..."
    end

    @movie.creator = current_user
    if @movie.save
      redirect_to @movie, notice: "Movie was successfully created. Don't forget to add your rating!"
    else
      render :new
    end
  end

  def destroy
    raise "no way" unless current_user.admin?

    @movie = Movie.find(params[:id])

    @movie.destroy

    redirect_to :back, notice: "Movie was successfully destroyed."
  end

  private

  def movie_params

  end

  def user_rating
    @user_rating ||= current_user.ratings.where(movie: @movie).first || @movie.ratings.build
  end
  helper_method :user_rating
end
