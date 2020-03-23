class UserRegistrationMailerPreview < ActionMailer::Preview
  def search_term_submitted_email
    user = User.last
    search_term = 'Tuple pairing'

    UserRegistrationMailer.search_term_submitted_email(user, search_term)
  end
end
