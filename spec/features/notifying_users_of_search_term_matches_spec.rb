require 'rails_helper'

RSpec.feature 'notifying users of search_term_matches' do
  scenario 'notifying users of search_term_matches' do
    when_a_search_term_has_been_found_in_two_episodes
    and_the_cron_job_runs_the_rake_task
    when_the_sidekiq_worker_runs_the_job
    then_the_user_is_notified_via_email
    and_the_notification_is_recorded
  end

  private

  def when_a_search_term_has_been_found_in_two_episodes
    @user = FactoryBot.create(:user)
    @search_term = FactoryBot.create(:search_term, created_at: 1.day.ago, user: @user)
    @search_term_match = FactoryBot.create(:search_term_match, search_term: @search_term, user: @user)
    @search_term_match = FactoryBot.create(:search_term_match, search_term: @search_term, user: @user)
  end

  def and_the_cron_job_runs_the_rake_task
    SearchTermMatchNotifierWorker.perform_async(SearchTermMatch.due_for_notification.pluck(:user_id))
  end

  def when_the_sidekiq_worker_runs_the_job
    wait_for_sidekiq
    SearchTermMatchNotifierWorker.drain
  end

  def then_the_user_is_notified_via_email
    emails_received = ActionMailer::Base.deliveries
    expect(emails_received.last.subject).to eq('Tuple pairing was namedropped on a podcast')
    expect(emails_received.last.to).to eq([@user.email])
  end

  def and_the_notification_is_recorded
    expect(@search_term_match.reload.notified_on).to_not be_nil
  end

  def wait_for_sidekiq
    sleep 0.5
  end
end


