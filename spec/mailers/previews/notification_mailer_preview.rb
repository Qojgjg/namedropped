# Preview all emails at http://localhost:3000/rails/mailers/episode_alert_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def notify_user_of_search_term_match
    search_term_match = SearchTermMatch.last
    NotificationMailer.notify_user_of_search_term_match(search_term_match)
  end
end

