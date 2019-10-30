module Crawler
  class PodcastCrawler
    require 'rss'

    def initialize(podcast)
      @podcast = podcast
    end

    def update_podcast_info
      podcast_details_from_rss = {}

      podcast_rss_url = podcast.rss

      open(podcast_rss_url) do |rss|
        feed = podcast_rss_feed(rss)

        podcast_details_from_rss[:title] = feed.channel.title
        podcast_details_from_rss[:description] = feed.channel.description
        podcast_details_from_rss[:language] = feed.channel.language
        podcast_details_from_rss[:website] = feed.channel.link
        podcast_details_from_rss[:itunes_owner_name] = feed.channel.itunes_owner.itunes_name
        podcast_details_from_rss[:itunes_owner_email] = feed.channel.itunes_owner.itunes_email
        podcast_details_from_rss[:itunes_explicit] = feed.channel.itunes_explicit == 'yes' ? true : false
        podcast_details_from_rss[:itunes_subtitle] = feed.channel.itunes_subtitle
        podcast_details_from_rss[:itunes_summary] = feed.channel.itunes_summary
        podcast_details_from_rss[:itunes_author] = feed.channel.itunes_author
        podcast_details_from_rss[:itunes_image] = feed.channel.image.url
      end

      podcast.update(podcast_details_from_rss)
    end

    def update_podcast_episodes_info
      episodes = []

      podcast_rss_url = podcast.rss
      open(podcast_rss_url) do |rss|
        feed = podcast_rss_feed(rss)

        episodes = feed.items.map do |item|
          episode_details_from_rss = {}

          episode_details_from_rss[:title] = item.title
          episode_details_from_rss[:description] = item.description
          episode_details_from_rss[:link_to_website] = item.link
          episode_details_from_rss[:guid] = item.guid.content
          episode_details_from_rss[:publication_date] = item.pubDate
          episode_details_from_rss[:enclosure_url] = item.enclosure.url
          episode_details_from_rss[:enclosure_length] = item.enclosure.length
          episode_details_from_rss[:enclosure_type] = item.enclosure.type
          episode_details_from_rss[:itunes_explicit] = item.itunes_explicit == 'yes' ? true : false
          episode_details_from_rss[:itunes_duration] = item.itunes_duration.hour.hours + item.itunes_duration.minute.minutes + item.itunes_duration.second.seconds

          podcast.episodes.create(episode_details_from_rss)
        end
      end
    end

    private

    attr_accessor :podcast

    def podcast_rss_feed(rss)
      @podcast_rss_feed ||= RSS::Parser.parse(rss)
    end
  end
end
