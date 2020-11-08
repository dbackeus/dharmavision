class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie, counter_cache: true

  validates_inclusion_of :rating, in: 1..10

  after_save :update_movie_average_rating

  # Ensure blank review values are saved as NULL
  def review=(review)
    super(review.presence)
  end

  private

  def update_movie_average_rating
    movie.update! average_rating: movie.ratings.average(:rating)
  end
end
