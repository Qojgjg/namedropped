class UserRegistrationMailer < ApplicationMailer
  default :from => "namedropped <notification@namedropped.co>"

  def search_term_submitted_email(user, search_term)
    @user = user
    @search_term = search_term

    mail(:to => @user.email,
         :subject => "We'll let you know when #{@search_term} is namedropped on a podcast")
  end
end
