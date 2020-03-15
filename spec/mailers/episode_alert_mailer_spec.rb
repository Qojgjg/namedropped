require "rails_helper"

RSpec.describe EpisodeAlertMailer, type: :mailer do
  let(:mail) { EpisodeAlertMailer.send_alert_email(user, search_term, episode) }
  let(:user) { double(:user, email: 'email@domain.com') }
  let(:search_term) { 'Balaji Srinivasan' }
  let(:episode) { instance_double('Episode', :episode, title: 'Podcast episode title') }

  it 'sends email from notification@namedropped.co' do
    expect(mail.from).to include('notification@namedropped.co')
  end

  it 'mentions the search term and episode title in the subject' do
    expect(mail.subject).to include('Balaji Srinivasan was namedropped on Podcast episode title')
  end

  it 'sends the email to the user' do
    expect(mail.to).to include(user.email)
  end
end
