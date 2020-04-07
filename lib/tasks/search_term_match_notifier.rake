namespace :search_term_match_notifier do
  desc "Notify the user of a search term match"
  task notify_user: :environment do
    SearchTermMatch.due_for_notification.find_each do |search_term_match|
      SearchTermMatchNotifierWorker.perform_async(search_term_match.id)
    end
  end
end
