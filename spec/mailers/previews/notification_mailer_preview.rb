# Preview all emails at http://localhost:3000/rails/mailers/episode_alert_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def notify_user_of_search_term_matches
    search_term_matches = SearchTermMatch.last(10)
    search_term = search_term_matches.last.search_term
    user = User.last
    NotificationMailer.notify_user_of_search_term_matches(user, search_term, search_term_matches)
  end
end

