require 'rails_helper'

RSpec.feature 'notifying users of search_term_matches' do
  scenario 'notifying users of search_term_matches' do
    when_a_search_term_has_been_found_in_two_episodes
    and_the_cron_job_runs_the_rake_task
    when_the_sidekiq_worker_runs_the_job
    then_the_user_is_notified_via_one_email
    and_the_notification_is_recorded
  end

  private

  def when_a_search_term_has_been_found_in_two_episodes
    @user = FactoryBot.create(:user)

    search_term = FactoryBot.create(:search_term, created_at: 1.day.ago, user: @user, name: 'Rothbard')
    podcast_one = FactoryBot.create(:podcast, title: 'Reason Editors Roundtable')
    podcast_two = FactoryBot.create(:podcast, title: 'Juan Ramon Rallo podcast')
    episode_one = FactoryBot.create(:episode, podcast: podcast_one)
    episode_two = FactoryBot.create(:episode, podcast: podcast_two)

    @search_term_match_one = FactoryBot.create(:search_term_match, search_term: search_term, user: @user, episode: episode_one)
    @search_term_match_two = FactoryBot.create(:search_term_match, search_term: search_term, user: @user, episode: episode_two)
  end

  def and_the_cron_job_runs_the_rake_task
    SearchTermMatchNotifierWorker.perform_async(SearchTermMatch.due_for_notification.pluck(:user_id))
  end

  def when_the_sidekiq_worker_runs_the_job
    wait_for_sidekiq
    SearchTermMatchNotifierWorker.drain
  end

  def then_the_user_is_notified_via_one_email
    @emails_received = ActionMailer::Base.deliveries
    only_one_email_is_sent
    expect(@emails_received.last.subject).to eq('Rothbard was namedropped on a podcast')
    expect(@emails_received.last.to).to eq([@user.email])
    the_email_lists_both_podcasts_where_the_search_term_appeared
  end

  def only_one_email_is_sent
    expect(@emails_received.count).to eq(1)
  end

  def the_email_lists_both_podcasts_where_the_search_term_appeared
    expect(@emails_received.last.body.encoded).to include('Reason Editors Roundtable')
    expect(@emails_received.last.body.encoded).to include('Juan Ramon Rallo podcast')
  end

  def and_the_notification_is_recorded
    expect(@search_term_match_one.reload.notified_on).to_not be_nil
    expect(@search_term_match_two.reload.notified_on).to_not be_nil
  end

  def wait_for_sidekiq
    sleep 0.5
  end
end


