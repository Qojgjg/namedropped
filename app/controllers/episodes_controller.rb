class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
    @podcast = @episode.podcast
    @search_term = "search_term"
  end
end
