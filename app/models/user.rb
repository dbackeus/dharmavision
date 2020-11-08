class User < ActiveRecord::Base
  devise :rememberable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates_presence_of :name

  has_many :ratings, dependent: :delete_all
  has_many :suggested_movies, class_name: "Movie"
end
