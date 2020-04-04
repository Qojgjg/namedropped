class SearchTermMatchNotifierService
  def initialize(search_term_match)
    @search_term_match = search_term_match
  end

  def notify
    NotificationMailer.notify_user_of_search_term_match(search_term_match).deliver_later
    search_term_match.update(notified_on: DateTime.now)
  end

  private

  attr_reader :search_term_match
end
