Podcast.find_each do |podcast|
  EpisodeFetchWorker.perform_async(podcast.id)
end
