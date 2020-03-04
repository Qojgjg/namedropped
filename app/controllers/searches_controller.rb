class SearchesController < ApplicationController
  after_action :track_action, only: :typeahead_search

  def typeahead_search
    @query = params[:q]
    cookies.encrypted[:search_term] = @query

    render json: formatted_results.to_json
  end

  def main_search
    @query = params[:q]
    render search_results
  end

  private

  def formatted_results
    results = Episode.search(@query)

    formatted_results = results.each_with_index.map { |result, index| { "id" => index+1 }.merge(result.fetch("_source")) }
  end

  def track_action
    ahoy.track "Search", request.path_parameters.merge(search_term: @query)
  end
end
