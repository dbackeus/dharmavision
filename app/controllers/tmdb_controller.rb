class TmdbController < ApplicationController
  def search
    query = params.require(:query)

    if year = query[/\d{4}$/]
      query_without_year = query[0..-5]
      with_year = TheMovieDb.search(query_without_year, year: year).fetch("results")
    end
    without_year = TheMovieDb.search(query).fetch("results")

    results = Array(with_year).concat(without_year)

    render json: results
  end
end
