module Omdb
  BASE_URL = "https://www.omdbapi.com"
  def self.find_by_imdb_id(imdb_id)
    response = Typhoeus.get("#{BASE_URL}?i=#{imdb_id}&apikey=#{ENV.fetch('OMDB_API_KEY')}")

    JSON.parse response.body, object_class: OpenStruct
  end
end
