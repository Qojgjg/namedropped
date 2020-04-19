class SearchTermMatchNotifierService
  def initialize(users_with_search_term_match_ids)
    @users_with_search_term_match_ids = users_with_search_term_match_ids
  end

  def notify
    users.find_each do |user|
      SearchTerm.with_matches_due_for_notification.where(user: user).each do |search_term|
        search_term_matches = search_term.search_term_matches.due_for_notification

        enqueue_email(user, search_term, search_term_matches)
        mark_search_term_matches_as_notified(search_term_matches)
      end
    end
  end

  private

  def users
    @users ||= User.where(id: @users_with_search_term_match_ids)
  end

  def mark_search_term_matches_as_notified(search_term_matches)
    search_term_matches.update_all(notified_on: DateTime.now)
  end

  def enqueue_email(user, search_term, search_term_matches)
    NotificationMailer.notify_user_of_search_term_matches(user, search_term, search_term_matches.to_a).deliver_later
  end
end
