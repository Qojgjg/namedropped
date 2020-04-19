class SearchTermMatchNotifierWorker
  include Sidekiq::Worker

  def perform(users_with_search_term_match_ids)
    search_term_match_notifier_service = SearchTermMatchNotifierService.new(users_with_search_term_match_ids)
    search_term_match_notifier_service.notify
  end
end
