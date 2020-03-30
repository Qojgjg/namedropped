class SearchTermCrawlerService
  def initialize(search_term, date_of_last_search_term_match)
    @search_term = search_term
    @date_of_last_search_term_match = date_of_last_search_term_match
  end

  def crawl_and_store_results
    crawl_episodes_for_search_term
    store_results
  end

  private

  def store_results
    formatted_results.each do |r|
      SearchTermMatch.create(episode_id: r.fetch(:id), search_term_id: search_term.id, user_id: search_term.user_id)
    end
  end

  def crawl_episodes_for_search_term
    @response = Episode.crawler_search(search_term.name, date_of_last_search_term_match)
  end

  attr_accessor :response, :search_term, :date_of_last_search_term_match

  def formatted_results
    response.results.map(&:_source)
  end
end
