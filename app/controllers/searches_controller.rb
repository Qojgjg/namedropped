class SearchesController < ApplicationController
  def show
    query = params[:q]
    # results = Podcast.where("title LIKE ?", "%#{query}%")
    
    results = Episode.search(query)
    render json: results.to_json
  end
end
