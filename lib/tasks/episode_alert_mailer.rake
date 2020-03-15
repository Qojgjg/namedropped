namespace :episode_alert_mailer do
  desc "Send email to alert about a search term appearing in an episode"
  task episode_alert_email: :environment do
    user = 'unused_variable'
    search_term = 'RipTide'
    episode = Episode.last

    EpisodeAlertMailer.send_alert_email(user, search_term, episode).deliver_later
  end
end
