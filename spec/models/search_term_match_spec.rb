require 'rails_helper'

RSpec.describe SearchTermMatch, type: :model do
  let(:search_term) { FactoryBot.create(:search_term, created_at: 5.days.ago) }
  let(:search_term_match_one) { FactoryBot.create(:search_term_match, search_term: search_term) }
  let(:search_term_match_two) { FactoryBot.create(:search_term_match) }
  let!(:search_term_match_with_notification) { FactoryBot.create(:search_term_match, :notified) }

  describe '.due_for_notification' do
    it 'returns all records that do not have a notification associated with it and which search_term has been created before today' do
      expect(SearchTermMatch.due_for_notification).to eq([search_term_match_one])
    end

    it 'does not return records that already have a notification associated with it' do
      expect(SearchTermMatch.due_for_notification).to_not include([search_term_match_with_notification])
    end

    it 'does not return records that have a search_term created today' do
      expect(SearchTermMatch.due_for_notification).to_not include([search_term_match_two])
    end
  end

  describe '.notified' do
    it 'returns all records that have received a notification' do
      expect(SearchTermMatch.notified).to eq([search_term_match_with_notification])
    end

    it 'does not return records that still need to be notified' do
      expect(SearchTermMatch.notified).to_not include([search_term_match_one])
      expect(SearchTermMatch.notified).to_not include([search_term_match_two])
    end
  end
end
