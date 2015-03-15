class Rating
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rating, type: Integer
  field :review, type: String

  belongs_to :movie
  belongs_to :user

  validates_presence_of :movie
  validates_presence_of :user
  validates_inclusion_of :rating, in: 1..10
  validates_uniqueness_of :movie_id, on: :create, scope: :user_id
end
