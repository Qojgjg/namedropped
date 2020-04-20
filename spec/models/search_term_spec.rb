require 'rails_helper'

RSpec.describe 'SearchTerm', type: :model do
  describe '.with_matches_due_for_notification' do
    let(:search_term_one) { FactoryBot.create(:search_term, created_at: 1.day.ago) }
    let(:search_term_two) { FactorBot.create(:search_term) }

    before do
      FactoryBot.create(:search_term_match, search_term: search_term_one)
    end

    it 'returns search_terms that were created before today where the search_term_match has not been notified' do
      search_terms = SearchTerm.with_matches_due_for_notification
      expect(search_terms).to eq([search_term_one])
    end

    context 'when there is one search_term with two search_term_matches' do
      before do
        FactoryBot.create(:search_term_match, search_term: search_term_one)
      end

      it 'returns one search_term record' do
        search_terms = SearchTerm.with_matches_due_for_notification
        expect(search_terms.count).to eq(1)
      end
    end
  end
end
