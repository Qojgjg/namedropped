require 'rails_helper'

RSpec.describe SearchTermCrawlerService do
  describe '#crawl_and_store_results' do
    let(:search_term) { double(:search_term, name: 'Nick Gillespie', id: 1, user_id: 100) }
    let(:search_term_match) { double(:search_term_match, created_at: date_of_last_search_term_match) }
    let(:search_term_matches) { [search_term_match] }
    let(:date_of_last_search_term_match) { double(:date) }
    let(:elasticsearch_response) { double(:elasticsearch_response, results: results) }
    let(:results) { [result] }
    let(:result) { double(:result, _source: _source) }
    let(:_source) do
      {
        id: 1840653,
        title: "A podcast for testing",
        description: "Nick Gillespie and the crew",
        publication_date: "2020-03-29T00:00:00.000Z",
        podcast: { itunes_image: "image_path" }
      }
    end

    let(:subject) { described_class.new(search_term) }

    before do
      allow(Episode).to receive(:crawler_search).with(search_term.name, date_of_last_search_term_match).and_return(elasticsearch_response)
      allow(search_term).to receive(:search_term_matches).and_return(search_term_matches)
    end

    it 'stores search results as search term matches' do
      expect(SearchTermMatch).to receive(:create).with(episode_id: 1840653, search_term_id: 1, user_id: 100)
      subject.crawl_and_store_results
    end

    context 'when there are 2 search results' do
      let(:results) { [result, result] }

      it 'stores both search results as search term matches' do
        expect(SearchTermMatch).to receive(:create).twice
        subject.crawl_and_store_results
      end
    end

    context 'when there are no search term matches' do
      let(:results) { [] }

      it 'does not store search results as search term matches' do
        expect(SearchTermMatch).to_not receive(:create)
        subject.crawl_and_store_results
      end
    end

    context 'when there are no previous search term matches' do
      let(:date_of_last_search_term_match) { nil }

      before do
        allow(elasticsearch_response).to receive(:results).and_return([])
      end

      it 'performs the episode search with the date of today' do
        expect(Episode).to receive(:crawler_search).with(search_term.name, Date.today).and_return(elasticsearch_response)
        subject.crawl_and_store_results
      end
    end
  end
end
