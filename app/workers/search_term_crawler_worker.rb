class SearchTermCrawlerWorker
  include Sidekiq::Worker

  def perform(search_term_id)
    search_term = SearchTerm.find(search_term_id)
    search_term_crawler_service = SearchTermCrawlerService.new(search_term)
    search_term_crawler_service.crawl_and_store_results
  end
end
