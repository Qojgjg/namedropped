require 'rails_helper'

RSpec.describe Searchable, elasticsearch: true do
  before do
    Timecop.freeze(Time.local(2020, 4, 1, 0, 0, 0))
  end

  after do
    Timecop.return
  end

  let(:publication_date) { Date.today }
  let(:episode_title) { 'Check out namedropped' }
  let(:episode_description) { 'Description of the podcast about namedropped' }
  let!(:episode_one) { FactoryBot.create(:episode, publication_date: publication_date, title: episode_title, description: episode_description) }
  let(:query) { 'namedropped' }

  describe '.typeahead_search' do
    context 'when there are multiple results' do
      let(:publication_date_old) { 1.day.ago }
      let!(:episode_two) { FactoryBot.create(:episode, podcast: episode_one.podcast, publication_date: publication_date_old, title: 'Another day another dollar', description: 'Hey ho namedropped', guid: 54321) }

      it 'sorts results by publication date, newest first' do
        expected_result = [episode_one, episode_two]
        sleep 1

        search_response = Episode.typeahead_search(query)
        expect(search_response.records.to_a).to eq(expected_result)
      end
    end

    context 'when the match is in the title' do
      let(:episode_description) { 'Foobar' }

      it 'finds matches of the query on the title' do
        expected_result = [{
          "id"=>1,
          "title"=>"Check out namedropped",
          "description"=>"Foobar",
          "publication_date"=>"2020-04-01T00:00:00.000Z",
          "podcast"=>{"itunes_image"=>nil}
        }]
        sleep 1

        search_response = Episode.typeahead_search(query)
        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end

    context 'when the match is in the description' do
      let(:episode_title) { 'Check out foo' }
      let(:description) { 'Description of the podcast about namedropped' }

      it 'finds matches of the query in the description' do
        expected_result = [{
          "id"=>1,
          "title"=>"Check out foo",
          "description"=>"Description of the podcast about namedropped",
          "publication_date"=>"2020-04-01T00:00:00.000Z",
          "podcast"=>{"itunes_image"=>nil}
        }]
        sleep 1

        search_response = Episode.typeahead_search(query)
        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end
  end

  describe '.main_search' do
    context 'when there are multiple results' do
      let(:publication_date_old) { 1.day.ago }
      let!(:episode_two) { FactoryBot.create(:episode, podcast: episode_one.podcast, publication_date: publication_date_old, title: 'Another day another dollar', description: 'Hey ho namedropped', guid: 54321) }

      it 'sorts results by publication date, newest first' do
        expected_result = [episode_one, episode_two]
        sleep 1

        search_response = Episode.main_search(query)
        expect(search_response.records.to_a).to eq(expected_result)
      end
    end

    context 'when the match is in the title' do
      let(:episode_description) { 'Foobar' }

      it 'finds matches of the query on the title' do
        expected_result = [{
          "id"=>1,
          "title"=>"Check out namedropped",
          "description"=>"Foobar",
          "publication_date"=>"2020-04-01T00:00:00.000Z",
          "podcast"=>{"itunes_image"=>nil}
        }]
        sleep 1

        search_response = Episode.main_search(query)
        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end

    context 'when the match is in the description' do
      let(:episode_title) { 'Check out foo' }
      let(:description) { 'Description of the podcast about namedropped' }

      it 'finds matches of the query in the description' do
        expected_result = [{
          "id"=>1,
          "title"=>"Check out foo",
          "description"=>"Description of the podcast about namedropped",
          "publication_date"=>"2020-04-01T00:00:00.000Z",
          "podcast"=>{"itunes_image"=>nil}
        }]
        sleep 1

        search_response = Episode.main_search(query)
        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end
  end

  describe '.crawler_search' do

    context 'when the query date is yesterday' do
      let(:date) { 1.day.ago }

      it 'returns matches from today only' do
        search_response = Episode.crawler_search(query, date)
        expected_result = [{
          "id"=>1,
          "title"=>"Check out namedropped",
          "description"=>"Description of the podcast about namedropped",
          "publication_date"=>"2020-04-01T00:00:00.000Z",
          "podcast"=>{"itunes_image"=>nil}
        }]
        sleep 1

        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end

    context 'when the query date is today and the publication was yesterday' do
      let(:publication_date) { 1.day.ago }
      let(:date) { Date.today }

      it 'returns no matches' do
        search_response = Episode.crawler_search(query, date)
        expected_result = []
        sleep 1

        expect(search_response.results.map(&:_source)).to eq(expected_result)
      end
    end
  end
end
