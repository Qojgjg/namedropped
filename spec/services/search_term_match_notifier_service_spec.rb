require 'rails_helper'

RSpec.describe SearchTermMatchNotifierService do
  let(:users_with_search_term_match_ids) { [user_one.id, user_two.id, user_three.id, user_four.id] }

  let(:user_one) { FactoryBot.create(:user) }
  let(:user_two) { FactoryBot.create(:user) }
  let(:user_three) { FactoryBot.create(:user) }
  let(:user_four) { FactoryBot.create(:user) }

  let(:search_term_one) { FactoryBot.create(:search_term, user: user_one, created_at: 1.day.ago) }
  let(:search_term_two) { FactoryBot.create(:search_term, user: user_two, created_at: 1.day.ago) }

  let(:subject) { described_class.new(users_with_search_term_match_ids) }
  let(:mail) { double(:mail, deliver_later: nil) }

  before do
    allow(NotificationMailer).to receive(:notify_user_of_search_term_matches).and_return(mail)
  end

  let!(:search_term_match_one) { FactoryBot.create(:search_term_match, user: user_one, search_term: search_term_one) }
  let!(:search_term_match_two) { FactoryBot.create(:search_term_match, user: user_two, search_term: search_term_two) }

  describe '#notify' do
    it 'sends the email' do
      expect(NotificationMailer).to receive(:notify_user_of_search_term_matches).with(user_one, search_term_one, search_term_one.search_term_matches)
      subject.notify
    end

    it 'marks the search_term_matches as notified' do
      subject.notify
      expect(search_term_match_one.reload.notified_on.to_date.to_s).to eq(Date.current.to_s)
    end

    it 'sends two emails' do
      expect(NotificationMailer).to receive(:notify_user_of_search_term_matches).twice
      subject.notify
    end

    it 'sends one email to each user with search_term_matches' do
      expect(NotificationMailer).to receive(:notify_user_of_search_term_matches).with(user_one, search_term_one, search_term_one.search_term_matches)
      expect(NotificationMailer).to receive(:notify_user_of_search_term_matches).with(user_two, search_term_two, search_term_two.search_term_matches)
      subject.notify
    end
  end
end
