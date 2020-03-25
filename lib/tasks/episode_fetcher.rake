namespace :episode_fetcher do
  desc "Fetch new podcast episodes"
  task fetch_episodes: :environment do
    Podcast.find_each do |podcast|
      EpisodeFetchWorker.perform_async(podcast.id)
      ActiveRecord::Base.connection.clear_query_cache
    end
  end
end
