module Crawler
  class PodcastCrawler
    require 'feedjira'
    require 'httparty'

    def initialize(podcast)
      @podcast = podcast
    end

    def update_podcast_info
      podcast_details_from_rss = {}

      podcast_rss_url = podcast.rss

      response_body = HTTParty.get(podcast_rss_url).body
      feed = Feedjira.parse(response_body)

      podcast_details_from_rss[:title] = feed.title
      podcast_details_from_rss[:description] = feed.description
      podcast_details_from_rss[:language] = feed.language
      podcast_details_from_rss[:website] = feed.url
      podcast_details_from_rss[:itunes_owner_name] = feed.itunes_owners.first.name
      podcast_details_from_rss[:itunes_owner_email] = feed.itunes_owners.first.email
      podcast_details_from_rss[:itunes_explicit] = feed.itunes_explicit == 'yes' ? true : false
      podcast_details_from_rss[:itunes_subtitle] = feed.itunes_subtitle
      podcast_details_from_rss[:itunes_summary] = feed.itunes_summary
      podcast_details_from_rss[:itunes_author] = feed.itunes_author
      podcast_details_from_rss[:itunes_image] = feed.itunes_image

      podcast.update(podcast_details_from_rss)

    rescue StandardError => e
      puts e.message
      puts podcast.title
    end

    def update_podcast_episodes_info
      episodes = []

      podcast_rss_url = podcast.rss

      response_body = HTTParty.get(podcast_rss_url).body
      feed = Feedjira.parse(response_body)

      episodes = feed.entries.map do |entry|
        episode_details_from_rss = {}

        episode_details_from_rss[:title] = entry.title
        episode_details_from_rss[:description] = entry&.itunes_summary
        episode_details_from_rss[:link_to_website] = entry.url
        episode_details_from_rss[:guid] = entry.entry_id
        episode_details_from_rss[:publication_date] = entry.published
        episode_details_from_rss[:enclosure_url] = entry.enclosure_url
        episode_details_from_rss[:enclosure_length] = entry.enclosure_length
        episode_details_from_rss[:enclosure_type] = entry.enclosure_type
        episode_details_from_rss[:itunes_explicit] = entry.itunes_explicit == 'yes' ? true : false
        episode_details_from_rss[:itunes_duration] = convert_time_to_seconds(entry.itunes_duration)

        podcast.episodes.create(episode_details_from_rss)
      end

    rescue StandardError => e
      puts e.message
      puts podcast.title
    end

    private

    attr_accessor :podcast

    def podcast_rss_feed(rss)
      @podcast_rss_feed ||= RSS::Parser.parse(rss)
    end

    def convert_time_to_seconds(time_string)
      return nil if time_string.blank?

      if time_string.count(":") == 1
        time_string = "00:" + time_string

        hours = time_string.to_datetime.hour.hours
        minutes = time_string.to_datetime.minute.minutes
        seconds = time_string.to_datetime.second.seconds

        (hours + minutes + seconds).seconds
      elsif time_string.count(":") == 2
        hours = time_string.to_datetime.hour.hours
        minutes = time_string.to_datetime.minute.minutes
        seconds = time_string.to_datetime.second.seconds

        (hours + minutes + seconds).seconds
      else
        time_string.to_i
      end
    end
  end
end
