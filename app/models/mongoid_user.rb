class MongoidUser
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "users"

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  field :name, type: String, default: ""
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  field :admin, type: Boolean, default: false

  has_many :ratings, dependent: :delete, class_name: "MongoidRating"
  has_many :suggested_movies, class_name: "MongoidMovie"

  validates_presence_of :name

  index({email: 1}, unique: true)
  index(reset_password_token: 1)
end