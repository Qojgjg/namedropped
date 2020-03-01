class SearchesController < ApplicationController
  def show
    query = params[:q]
    cookies.encrypted[:search_term] = query

    render json: formatted_results(query).to_json
  end

  private

  def formatted_results(query)
    results = Episode.search(query)

    formatted_results = results.each_with_index.map { |result, index| { "id" => index+1 }.merge(result.fetch("_source")) }
  end
end
