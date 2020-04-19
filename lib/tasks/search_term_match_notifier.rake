namespace :search_term_match_notifier do
  desc "Notify the user of a search term match"
  task notify_user: :environment do
    SearchTermMatchNotifierWorker.perform_async(SearchTermMatch.due_for_notification.pluck(:user_id))
  end
end
