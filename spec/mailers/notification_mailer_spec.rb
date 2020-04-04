require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:mail) { NotificationMailer.notify_user_of_search_term_match(search_term_match) }
  let(:search_term_match) { double(:search_term_match, user: user, search_term: search_term, episode: episode) }

  let(:user) { double(:user, email: 'email@domain.com') }
  let(:search_term) { double(:search_term, name: 'Balaji Srinivasan') }
  let(:episode) { instance_double('Episode', :episode, title: 'Podcast episode title') }

  it 'sends email from notification@namedropped.co' do
    expect(mail.from).to include('notification@namedropped.co')
  end

  it 'mentions the search term in the subject' do
    expect(mail.subject).to include('Balaji Srinivasan was namedropped on a podcast')
  end

  it 'sends the email to the user' do
    expect(mail.to).to include(user.email)
  end
end
