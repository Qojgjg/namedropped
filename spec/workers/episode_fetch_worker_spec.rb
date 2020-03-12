require 'rails_helper'

RSpec.describe EpisodeFetchWorker do
  let(:worker) { EpisodeFetchWorker.new }
  let(:podcast_id) { 1 }
  let(:podcast) { double(:podcast) }
  let(:crawler) { double(:crawler, update_podcast_episodes_info: nil) }

  before do
    allow(Podcast).to receive(:find).with(podcast_id).and_return(podcast)
    allow(Crawler::PodcastCrawler).to receive(:new).with(podcast).and_return(crawler)
  end

  describe '#perform' do
    it 'finds the podcast' do
      expect(Podcast).to receive(:find).with(podcast_id)
      worker.perform(podcast_id)
    end

    it 'instantiates the PodcastCrawler with the podcast' do
      expect(Crawler::PodcastCrawler).to receive(:new).with(podcast).and_return(crawler)
      worker.perform(podcast_id)
    end

    it 'fetches all episodes of the podcast' do
      expect(crawler).to receive(:update_podcast_episodes_info)
      worker.perform(podcast_id)
    end
  end
end
