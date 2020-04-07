class SearchTermMatchNotifierWorker
  include Sidekiq::Worker

  def perform(search_term_match_id)
    search_term_match = SearchTermMatch.find(search_term_match_id)
    search_term_match_notifier_service = SearchTermMatchNotifierService.new(search_term_match)
    search_term_match_notifier_service.notify
  end
end
