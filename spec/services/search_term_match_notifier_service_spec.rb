require 'rails_helper'

RSpec.describe SearchTermMatchNotifierService do
  let(:search_term_match) { double(:search_term_match) }
  let(:subject) { described_class.new(search_term_match) }

  before do
    allow(search_term_match).to receive(:update)
    allow(NotificationMailer).to receive_message_chain(:notify_user_of_search_term_match, :deliver_later)
  end

  describe '#notify' do
    it 'sends the email' do
      expect(NotificationMailer).to receive_message_chain(:notify_user_of_search_term_match, :deliver_later)
      subject.notify
    end

    it 'creates a notification record' do
      expect(search_term_match).to receive(:update).with(notified_on: DateTime.now)  
      subject.notify
    end
  end
end
