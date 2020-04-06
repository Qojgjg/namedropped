require 'rails_helper'

RSpec.describe SearchTermCrawlerWorker do
  let(:worker) { SearchTermCrawlerWorker.new }
  let(:search_term_id) { 1 }
  let(:search_term) { double(:search_term) }
  let(:search_term_crawler_service) { double(:search_term_crawler_service) }

  before do
    allow(SearchTerm).to receive(:find).with(search_term_id).and_return(search_term)
    allow(SearchTermCrawlerService).to receive(:new).with(search_term).and_return(search_term_crawler_service)
    allow(search_term_crawler_service).to receive(:crawl_and_store_results)
  end

  describe '#perform' do
    it 'finds the search term' do
      expect(SearchTerm).to receive(:find).with(search_term_id).and_return(search_term)
      worker.perform(search_term_id)
    end

    it 'instantiates the SearchTermCrawlerService with the search_term' do
      expect(SearchTermCrawlerService).to receive(:new).with(search_term).and_return(search_term_crawler_service)
      worker.perform(search_term_id)
    end

    it 'crawls and stores search_term results' do
      expect(search_term_crawler_service).to receive(:crawl_and_store_results)
      worker.perform(search_term_id)
    end
  end
end
