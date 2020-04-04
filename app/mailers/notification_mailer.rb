class NotificationMailer < ApplicationMailer
  default :from => "namedropped <notification@namedropped.co>"

  def notify_user_of_search_term_match(search_term_match)
    @user = search_term_match.user
    @search_term = search_term_match.search_term.name
    @episode = search_term_match.episode

    mail(:to => @user.email,
         :subject => "#{@search_term} was namedropped on a podcast")
  end
end
