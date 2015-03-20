class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :imdb_id, type: String
  field :plot, type: String
  field :year, type: Integer
  field :mpaa, type: String

  embeds_many :titles, class_name: "MovieTitle"

  has_many :ratings, dependent: :delete

  before_validation :set_attributes_from_imdb, on: :create, if: -> { imdb_movie.title.present? }

  validates_presence_of :title
  validates_presence_of :imdb_id
  validates_uniqueness_of :imdb_id
  validate :validate_imdb_id, on: :create, if: :imdb_id

  index({imdb_id: 1}, unique: true)

  def average_rating
    average = ratings.sum(&:rating).to_f / ratings.length

    if average.nan?
      0.0
    else
      average == 10 ? 10 : average.round(1)
    end
  end

  def imdb_id=(id_or_url)
    if id_or_url =~ /tt(\d{1,})/
      super($1)
    else
      super(id_or_url)
    end
  end

  def serializable_hash(options = {})
    super.merge(average_rating: average_rating, id: id.to_s).except(:_id)
  end

  private
  def imdb_movie
    @imdb_movie ||= Imdb::Movie.new(imdb_id)
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

  def set_accepted_status
    update_attribute(:accepted, true) if !accepted && ratings.count >= 5
  end

  def validate_imdb_id
    errors[:imdb_id] << "needs to be a valid url" unless imdb_movie.title.present?
  end
end
