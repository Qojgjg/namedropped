class EpisodeAlertMailer < ApplicationMailer
  default :from => "namedropped <notification@namedropped.co>"

  def send_alert_email(user, search_term, episode)
    @user = OpenStruct.new(email: 'rschultzejena@gmail.com')
    @search_term = search_term
    @episode = episode

    mail(:to => @user.email,
         :subject => "#{search_term} was namedropped on #{episode.title}")
  end
end
