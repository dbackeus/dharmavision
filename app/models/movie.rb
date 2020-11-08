class Movie < ActiveRecord::Base
  belongs_to :creator, class_name: "User"
  has_many :ratings, dependent: :delete_all
  has_many :titles, class_name: "MovieTitle", dependent: :delete_all

  before_validation :populate_from_the_the_movie_db, on: :create, if: :tmdb_id

  validates_presence_of :tmdb_id
  validates_presence_of :creator
  validates_presence_of :title
  validates_presence_of :imdb_id
  validates_presence_of :original_language
  validates_presence_of :original_title
  validates_presence_of :released_on

  scope :suggested, -> { where("ratings_count < 5") }
  scope :listed, -> { where("ratings_count >= 5") }

  def poster_url(width = 500)
    if tmdb_poster_path
      # https://developers.themoviedb.org/3/getting-started/images
      "https://image.tmdb.org/t/p/w#{width}#{tmdb_poster_path}"
    elsif omdb_poster_url
      # Unoffocial image transformation API built into the URL format, eg:
      # https://m.media-amazon.com/images/M/MV5BMjE1NjQ5ODc2NV5BMl5BanBnXkFtZTgwOTM5ODIxNjE@._V1_SX300.jpg
      # No guarantees that the arguments stay the same or that SX300 remains the default size.
      omdb_poster_url.sub("SX300", "SX#{width}")
    end
  end

  def tmdb_movie
    @tmdb_movie ||= TheMovieDb.movie_details(tmdb_id)
  end

  def year
    released_on.year
  end

  def populate_from_the_the_movie_db
    self.title = tmdb_movie.title
    self.imdb_id = tmdb_movie.imdb_id
    self.original_language = tmdb_movie.original_language
    self.original_title = tmdb_movie.original_title
    self.overview = tmdb_movie.overview
    self.released_on = tmdb_movie.release_date
    self.tmdb_poster_path = tmdb_movie.poster_path
    self.omdb_poster_url = Omdb.find_by_imdb_id(imdb_id).Poster unless tmdb_poster_path

    if us_release = tmdb_movie.release_dates.results.find { |release| release.iso_3166_1 == "US" }
      self.mpaa_rating = us_release.release_dates.map(&:certification).find(&:present?)
    end

    self.titles = [title, original_title].concat(tmdb_movie.alternative_titles.titles.map(&:title)).uniq.map do |title|
      MovieTitle.new(title: title)
    end
  end
end
