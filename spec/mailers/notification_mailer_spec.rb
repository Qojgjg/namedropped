require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:mail) { NotificationMailer.notify_user_of_search_term_matches(user, search_term, search_term_matches) }
  let(:search_term_match_one) { double(:search_term_match_one, user: user, search_term: search_term, episode: episode_one) }
  let(:search_term_match_two) { double(:search_term_match_one, user: user, search_term: search_term, episode: episode_two) }
  let(:search_term_matches) { [search_term_match_one, search_term_match_two] }

  let(:user) { double(:user, email: 'email@domain.com') }
  let(:search_term) { double(:search_term, name: 'Balaji Srinivasan') }
  let(:episode_one) { instance_double('Episode', :episode, title: 'Podcast episode title one', podcast: podcast_one) }
  let(:episode_two) { instance_double('Episode', :episode, title: 'Podcast episode title two', podcast: podcast_two) }
  let(:podcast_one) { instance_double('Podcast', :podcast, title: 'Podcast One') }
  let(:podcast_two) { instance_double('Podcast', :podcast, title: 'Podcast Two') }

  it 'sends email from notification@namedropped.co' do
    expect(mail.from).to include('notification@namedropped.co')
  end

  it 'mentions the search term in the subject' do
    expect(mail.subject).to include('Balaji Srinivasan was namedropped on a podcast')
  end

  it 'sends the email to the user' do
    expect(mail.to).to include(user.email)
  end

  it 'mentions both matches in the body of the email' do
    expect(mail.body.encoded).to match("Podcast One")
    expect(mail.body.encoded).to match("Podcast Two")
  end
end
