module TheMovieDb
  BASE_URL = "https://api.themoviedb.org/3".freeze
  HEADERS = {
    "Content-Type" => "application/json;charset=utf-8",
    "Accept" => "application/json",
  }.freeze

  HttpError = Class.new(StandardError)

  def self.movie_details(movie_id)
    JSON.parse get("movie/#{movie_id}", append_to_response: "alternative_titles,release_dates").body, object_class: OpenStruct
  end

  def self.search(query, year: nil)
    JSON.parse get("search/movie", query: query, include_adult: false, year: year).body
  end

  def self.get(path, params = {})
    params[:api_key] = ENV.fetch("TMDB_API_KEY")

    response = Typhoeus.get(
      "#{BASE_URL}/#{path}",
      headers: HEADERS,
      params: params,
    )

    raise HttpError, "#{response.code}, #{response.body}" unless response.success?

    response
  end
end
