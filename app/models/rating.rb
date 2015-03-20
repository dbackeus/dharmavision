class Rating
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rating, type: Integer
  field :review, type: String

  belongs_to :movie, index: true
  belongs_to :user, index: true

  validates_presence_of :movie
  validates_presence_of :user
  validates_inclusion_of :rating, in: 1..10
  validates_uniqueness_of :movie_id, on: :create, scope: :user_id

  after_save :update_movie_average_rating

  private

  def update_movie_average_rating
    movie.refresh_average_rating
  end
end
