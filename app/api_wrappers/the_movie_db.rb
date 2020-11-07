module TheMovieDb
  BASE_URL = "https://api.themoviedb.org/3".freeze
  HEADERS = {
    "Content-Type" => "application/json;charset=utf-8",
    "Accept" => "application/json",
    "Authorization" => "Bearer #{ENV.fetch('THEMOVIEDB_API_KEY_V4')}"
  }.freeze

  HttpError = Class.new(StandardError)

  def self.movie_details(movie_id)
    JSON.parse get("movie/#{movie_id}", append_to_response: "alternative_titles,release_dates").body, object_class: OpenStruct
  end

  def self.search(query)
    JSON.parse get("search/movie", query: query, include_adult: false).body
  end

  def self.get(path, params = {})
    response = Typhoeus.get(
      "#{BASE_URL}/#{path}",
      headers: HEADERS,
      params: params,
    )

    Rails.logger.debug response.headers

    raise HttpError, "#{response.code}, #{response.body}" unless response.success?

    response
  end
end
