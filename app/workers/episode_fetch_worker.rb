require_relative '../../lib/crawler/podcast_crawler.rb'

class EpisodeFetchWorker
  include Sidekiq::Worker

  def perform(podcast_id)
    podcast = Podcast.find(podcast_id)
    crawler = Crawler::PodcastCrawler.new(podcast)
    crawler.update_podcast_episodes_info
  end
end
