class MongoidMovie
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "movies"

  field :title, type: String
  field :imdb_id, type: String
  field :tmdb_id, type: Integer
  field :tmdb_poster_path, type: String
  field :tmdb_backdrop_path, type: String
  field :tmdb_mpaa, type: String
  field :plot, type: String
  field :year, type: Integer
  field :mpaa, type: String
  field :average_rating, type: Float, default: 0.0
  field :ratings_count, type: Integer, default: 0

  embeds_many :titles, class_name: "MongoidMovieTitle"

  belongs_to :creator, class_name: "MongoidUser"

  has_many :ratings, dependent: :delete

  before_validation :set_attributes_from_imdb, on: :create, if: -> { found_on_imdb? }
  before_validation :set_attributes_from_tmdb, on: :create, if: -> { found_on_tmdb? }

  validates_presence_of :title
  validates_presence_of :imdb_id
  validates_presence_of :creator
  validates_uniqueness_of :imdb_id
  validate :validate_imdb_id, on: :create, if: :imdb_id

  index({imdb_id: 1}, unique: true)
  index({average_rating: 1})

  searchkick word_start: %i[title]

  def self.suggested
    where(:ratings_count.lt => 5)
  end

  def self.listed
    where(:ratings_count.gt => 4)
  end

  def search_data
    as_json(only: :title).merge("titles" => titles.map(&:title))
  end

  def mpaa_rating
    tmdb_mpaa.presence || mpaa.to_s.split.second
  end

  def poster_url(size = "w500")
    return nil unless tmdb_poster_path.present?

    "#{THEMOVIEDB_CONFIG['secure_base_url']}#{size}#{tmdb_poster_path}"
  end

  def refresh_average_rating
    update_attributes!(average_rating: aggregate_average_rating)
  end

  def imdb_id=(id_or_url)
    if id_or_url =~ /tt(\d{1,})/
      super($1)
    else
      super(id_or_url)
    end
  end

  def serializable_hash(options = {})
    super.merge(id: id.to_s).except(:_id)
  end

  private
  def imdb_movie
    @imdb_movie ||= Imdb::Movie.new(imdb_id)
  end

  def rotten_movie
    return @rotten_movie if @rotten_movie

    movie = RottenTomatoes::RottenMovie.find imdb: imdb_id

    if movie.error
      nil
    else
      @rotten_movie = movie
    end
  end

  def tmdb_movie
    return @tmdb_movie if @tmdb_movie

    response = Tmdb::Find.imdb_id("tt#{imdb_id}")

    type, results = response.detect { |type, results| results.any? }

    if type
      tmdb_class = type == "movie_results" ? Tmdb::Movie : Tmdb::TV
      params = { append_to_response: "alternative_titles,releases" }

      @tmdb_movie = TmdbMovie.new tmdb_class.detail(results.first["id"], params)
    end
  end

  def set_attributes_from_imdb
    self.title = imdb_movie.title
    self.plot = imdb_movie.plot
    self.year = imdb_movie.year
    self.mpaa = imdb_movie.mpaa_rating
    self.titles = imdb_movie.also_known_as.map do |title|
      MovieTitle.new(version: title[:version], title: title[:title])
    end
  end

  def set_attributes_from_tmdb
    self.tmdb_id = tmdb_movie["id"]
    self.plot = self.plot.presence || tmdb_movie["overview"]
    self.tmdb_poster_path = tmdb_movie["poster_path"]
    self.tmdb_backdrop_path = tmdb_movie["backdrop_path"]
    self.tmdb_mpaa = tmdb_movie.mpaa
  end

  def validate_imdb_id
    errors[:imdb_id] << "needs to be a valid imdb id or url" unless found_on_imdb?
  end

  def aggregate_average_rating
    Rating.collection.aggregate(
      ["$match" => { "movie_id" => id }],
      ["$group" => { "_id" => "$movie_id", "average_rating" => { "$avg" => "$rating" }}]
    ).first["average_rating"]
  end

  def found_on_imdb?
    imdb_movie.title.present?
  end

  def found_on_tmdb?
    found_on_imdb? && tmdb_movie.present?
  end
end
