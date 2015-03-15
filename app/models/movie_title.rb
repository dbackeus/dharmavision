class MovieTitle
  include Mongoid::Document

  field :version, type: String
  field :title, type: String

  embedded_in :movie

  validates_presence_of :version
  validates_presence_of :title

  def serializable_hash(options = {})
    super.except("_id")
  end
end
