class ImdbController < ApplicationController
  def search
    search = Imdb::Search.new(params[:query])

    render json: search.movies[0..9].to_json
  end
end
