class SearchesController < ApplicationController
  protect_from_forgery except: :main_search

  def typeahead_search
    if verified_request?
      @typeahead_query = params[:q]
      cookies.encrypted[:search_term] = @typeahead_query

      track_action(name: 'typeahead_search', query: @typahead_query)

      render json: formatted_results_typeahead.to_json
    else
      render json: {}.to_json, status: 403
    end
  end

  def main_search
    @main_query = params[:q]
    cookies.encrypted[:search_term] = @main_query

    track_action(name: 'main_search', query: @main_query)

    @search_result_props = formatted_results_main

    render :show
  end

  private

  attr_accessor :results

  def formatted_results_typeahead
    @results = Episode.typeahead_search(@typeahead_query)
    format_results
  end

  def formatted_results_main
    @results = Episode.main_search(@main_query)
    format_results
  end

  def track_action(name:, query:)
    ahoy.track name, request.path_parameters.merge(search_term: query)
  end

  def verified_request?
    valid_request_origin? && any_authenticity_token_valid?
  end

  def format_results
    results.map { |result| result.fetch("_source") }
  end
end
