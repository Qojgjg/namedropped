class NotificationMailer < ApplicationMailer
  default :from => "namedropped <notification@namedropped.co>"

  def notify_user_of_search_term_matches(user, search_term, search_term_matches)
    @user = user
    @search_term = search_term.name
    @search_term_matches = search_term_matches

    mail(:to => @user.email,
         :subject => "#{@search_term} was namedropped on a podcast")
  end
end
