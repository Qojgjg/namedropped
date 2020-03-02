require_relative 'lib/crawler/podcast_crawler'

module Searchable; end

Podcast.find_each do |podcast|
  crawler = Crawler::PodcastCrawler.new(podcast)
  crawler.update_podcast_episodes_info
end

# run with bundle exec rails runner lib/scripts/episode_fetcher.rb > output.txt
