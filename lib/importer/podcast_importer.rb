module Importer
  require 'json'

  class PodcastImporter
    # take json files
    # import data into podcasts table
    def initialize(json_file)
      @json_file = json_file
    end

    def json_content
      @file_content ||= File.read(@json_file)
      JSON.parse(@file_content)
    end

    def podcasts_in_json
      podcasts = json_content["podcasts"]
      podcasts.each do |podcast|
        next unless podcast

        extracted_details = podcast_details_extractor(podcast)
        Podcast.create(extracted_details)
      end
    end

    def podcast_details_extractor(podcast)
      details = podcast["podcast_details"]

      {
        title: details.fetch("podcast_name", "title"),
        description: details["description"],
        language: details["language"],
        website: details["website"],
        rss: details["rss_feed_url"],
        country: details["country"],
        itunes_image: details["itunes_image"],
        itunes_explicit: details["content_rating"] != "clean",
        rating_count: details["rating_count"],
        average_rating: details["average_rating"],
        itunes_complete: nil,
        itunes_author: nil,
        itunes_owner_name: nil,
        itunes_owner_email: nil,
        itunes_type: details["itunes_type"],
        itunes_subtitle: nil,
        itunes_summary: nil,
        itunes_id: details["itunes_id"],
        categories: Category.where(name: details["categories"])
      }

    end
  end
end

# require_relative 'lib/importer/podcast_importer'

# DIRECTORY_OF_FILES_WITH_PODCAST_DETAILS = './db/podcast_seed_data/podcasts_as_json'

# Dir.children(DIRECTORY_OF_FILES_WITH_PODCAST_DETAILS).each do |filename|
#   next unless filename.ends_with?('.json')

#   podcast_importer = Importer::PodcastImporter.new(DIRECTORY_OF_FILES_WITH_PODCAST_DETAILS + '/' + filename)
#   podcast_importer.podcasts_in_json
# end
