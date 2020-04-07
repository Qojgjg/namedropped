require 'rails_helper'

RSpec.describe SearchTermMatchNotifierWorker do
  let(:worker) { SearchTermMatchNotifierWorker.new }
  let(:search_term_match_id) { 1 }
  let(:search_term_match) { double(:search_term_match) }
  let(:search_term_match_notifier_service) { double(:search_term_match_notifier_service) }

  before do
    allow(SearchTermMatch).to receive(:find).with(search_term_match_id).and_return(search_term_match)
    allow(SearchTermMatchNotifierService).to receive(:new).with(search_term_match).and_return(search_term_match_notifier_service)
    allow(search_term_match_notifier_service).to receive(:notify)
  end

  describe '#perform' do
    it 'find the search_term_match' do
      expect(SearchTermMatch).to receive(:find).with(search_term_match_id).and_return(search_term_match)
      worker.perform(search_term_match_id)
    end

    it 'instantiates the SearchTermMatchNotifierService with the search_term_match' do
      expect(SearchTermMatchNotifierService).to receive(:new).with(search_term_match).and_return(search_term_match_notifier_service)
      worker.perform(search_term_match_id)
    end

    it 'notifies the user' do
      expect(search_term_match_notifier_service).to receive(:notify)
      worker.perform(search_term_match_id)
    end
  end
end
