class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :imdb_id, type: String
  field :rotten_id, type: Integer
  field :rotten_poster, type: String
  field :omdb_poster, type: String
  field :omdb_plot, type: String
  field :tmdb_id, type: Integer
  field :tmdb_poster_path, type: String
  field :tmdb_backdrop_path, type: String
  field :plot, type: String
  field :year, type: Integer
  field :mpaa, type: String
  field :average_rating, type: Float, default: 0.0

  embeds_many :titles, class_name: "MovieTitle"

  belongs_to :creator, class_name: "User"

  has_many :ratings, dependent: :delete

  before_validation :set_attributes_from_imdb, on: :create, if: -> { found_on_imdb? }
  before_validation :set_attributes_from_rotten_tomatoes, on: :create, if: -> { found_on_rotten_tomatoes? }
  before_validation :set_attributes_from_omdb, on: :create, if: -> { found_on_omdb? }
  before_validation :set_attributes_from_tmdb, on: :create, if: -> { found_on_tmdb? }

  validates_presence_of :title
  validates_presence_of :imdb_id
  validates_presence_of :creator
  validates_uniqueness_of :imdb_id
  validate :validate_imdb_id, on: :create, if: :imdb_id

  index({imdb_id: 1}, unique: true)
  index({average_rating: 1})

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

  def omdb_movie
    @omdb_movie ||= Omdb::Api.new.find("tt#{imdb_id}", false, "full")[:movie]
  end

  def tmdb_movie
    @tmdb_movie ||= Tmdb::Find.imdb_id("tt#{imdb_id}").values.detect(&:any?).try(:first)
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

  def set_attributes_from_omdb
    self.omdb_plot = omdb_movie.plot
    self.omdb_poster = omdb_movie.poster
  end

  def set_attributes_from_tmdb
    self.tmdb_id = tmdb_movie["id"]
    self.tmdb_poster_path = tmdb_movie["poster_path"]
    self.tmdb_backdrop_path = tmdb_movie["backdrop_path"]
  end

  def set_attributes_from_rotten_tomatoes
    self.rotten_id = rotten_movie.id
    self.rotten_poster = rotten_movie.posters.detailed.gsub(/https?/, "https")
  end

  def set_accepted_status
    update_attribute(:accepted, true) if !accepted && ratings.count >= 5
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

  def found_on_rotten_tomatoes?
    found_on_imdb? && rotten_movie.present?
  end

  def found_on_omdb?
    found_on_imdb? && omdb_movie.present?
  end

  def found_on_tmdb?
    found_on_imdb? && tmdb_movie.present?
  end
end
