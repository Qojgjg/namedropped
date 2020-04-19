require 'rails_helper'

RSpec.describe SearchTermMatchNotifierWorker do
  let(:worker) { SearchTermMatchNotifierWorker.new }
  let(:user) { instance_double('User', :user, id: 1) }
  let(:user_ids) { [user.id] }
  let(:search_term_match_notifier_service) { instance_double('SearchTermMatchNotifierService', :search_term_match_notifier_service) }

  before do
    allow(SearchTermMatchNotifierService).to receive(:new).with(user_ids).and_return(search_term_match_notifier_service)
    allow(search_term_match_notifier_service).to receive(:notify)
  end

  describe '#perform' do
    it 'instantiates the SearchTermMatchNotifierService with the search_term_match' do
      expect(SearchTermMatchNotifierService).to receive(:new).with(user_ids).and_return(search_term_match_notifier_service)
      worker.perform(user_ids)
    end

    it 'notifies the user' do
      expect(search_term_match_notifier_service).to receive(:notify)
      worker.perform(user_ids)
    end
  end
end
