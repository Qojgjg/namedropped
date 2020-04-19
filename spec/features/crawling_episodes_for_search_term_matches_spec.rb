require 'rails_helper'

RSpec.feature 'crawling episodes for a search_term_match', elasticsearch: true do
  scenario 'crawling epispdes for a search_term_match' do
    given_one_matching_episode_exists
    when_a_user_has_a_search_term
    and_the_cron_job_runs_the_rake_task
    then_the_sidekiq_worker_runs_the_job
    and_the_matches_are_stored
  end

  private

  def when_a_user_has_a_search_term
    FactoryBot.create(:search_term, name: 'Ruby', created_at: 1.day.ago)
  end

  def and_the_cron_job_runs_the_rake_task
    SearchTerm.find_each do |search_term|
      SearchTermCrawlerWorker.perform_async(search_term.id)
    end
  end

  def then_the_sidekiq_worker_runs_the_job
    wait_for_sidekiq
    SearchTermCrawlerWorker.drain
  end

  def and_the_matches_are_stored
    expect(SearchTermMatch.count).to eq(1)
    expect(SearchTermMatch.last.episode.title).to eq('Fun with Ruby on Rails')
  end

  def given_one_matching_episode_exists
    FactoryBot.create(:episode, title: 'Fun with Ruby on Rails')
    FactoryBot.create(:episode, title: 'Fun with Python')
  end

  def wait_for_sidekiq
    sleep 1
  end
end


