class EpisodesController < ApplicationController
  after_action :track_action, only: :show

  def show
    @episode = Episode.find(params[:id])
    @podcast = @episode.podcast
    @search_term = cookies.encrypted[:search_term]
  end

  private

  def track_action
    ahoy.track "Show Episode", request.path_parameters.merge(search_term: @search_term)
  end
end
