namespace :search_term_crawler do
  desc "Search for appearances of the search term in episodes"
  task crawl_episodes: :environment do
    SearchTerm.find_each do |search_term|
      SearchTermCrawlerWorker.perform_async(search_term.id)
    end
  end
end
