module Searchable; end

Podcast.each_find do |podcast|
  crawler = Crawler::PodcastCrawler.new(podcast)
  crawler.update_podcast_episodes_info
end

# run with bundle exec rails runner > output.txt
