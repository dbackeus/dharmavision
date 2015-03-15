class Movie
  include Mongoid::Document

  field :title, type: String
  field :imdb_id, type: String
  field :plot, type: String
  field :year, type: Integer
  field :mpaa, type: String

  has_many :ratings

  validates_presence_of :title
  validates_presence_of :imdb_id
  validates_uniqueness_of :imdb_id
  validate :validate_imdb_id, on: :create, if: :imdb_id

  before_validation :set_attributes_from_imdb, on: :create

  def imdb_id=(id_or_url)
    if id_or_url =~ /tt(\d{1,})/
      super($1)
    else
      super(id_or_url)
    end
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
  rescue OpenURI::HTTPError # This gets raised by Imdb::Movie when requesting year on nonexisting movie for unknown reason
  end

  def set_accepted_status
    update_attribute(:accepted, true) if !accepted && ratings.count >= 5
  end

  def validate_imdb_id
    errors[:imdb_id] << "needs to be a valid url" unless imdb_movie.title.present?
  end
end
