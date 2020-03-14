# Preview all emails at http://localhost:3000/rails/mailers/episode_alert_mailer
class EpisodeAlertMailerPreview < ActionMailer::Preview
  def send_alert_email
    user = OpenStruct.new(email: 'email@domain.com')
    search_term = 'Search Term'
    episode = Episode.last

    EpisodeAlertMailer.send_alert_email(user, search_term, episode)
  end
end
