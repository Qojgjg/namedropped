require "rails_helper"

RSpec.describe UserRegistrationMailer, type: :mailer do
  let(:mail) { UserRegistrationMailer.search_term_submitted_email(user, search_term) }
  let(:user) { instance_double('User', :user, email: 'email@domain.com') }
  let(:search_term) { 'Balaji Srinivasan' }

  it 'sends the email from notification@namedropped.co' do
    expect(mail.from).to include('notification@namedropped.co')
  end

  it 'mentions the search term in the subject' do
    expect(mail.subject).to include("We'll let you know when Balaji Srinivasan is namedropped on a podcast")
  end

  it 'sends the email to the user' do
    expect(mail.to).to include(user.email)
  end
end
