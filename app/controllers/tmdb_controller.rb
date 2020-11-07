class TmdbController < ApplicationController
  def search
    results = TheMovieDb.search(params[:query]).fetch("results")
    render json: results.as_json
  end
end
