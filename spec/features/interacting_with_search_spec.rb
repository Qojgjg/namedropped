require 'rails_helper'

RSpec.feature 'interacting with search', js: true, elasticsearch: true do

  before do
    FactoryBot.create(:episode, title: 'Nick Gillespie and the Reason Editor Roundtable')
  end

  scenario 'searching for a person' do
    sleep 2
    when_i_visit_the_homepage
    and_i_search_for_the_name_nick_gillespie
    then_i_see_results_for_episodes_mentioning_nick_gillespie
  end

  scenario 'viewing a search result' do
    sleep 2
    when_i_search_for_the_name_nick_gillespie
    and_i_click_on_on_the_first_search_result
    then_i_see_information_about_the_episode_the_term_appeared_in
  end

  private

  def when_i_visit_the_homepage
    visit root_path
  end

  def and_i_search_for_the_name_nick_gillespie
    search_input_field = find(:xpath, "/html/body/div[2]/div/div/div[1]/div[1]/input")
    search_input_field.set('Nick Gillespie')
    sleep 2
    find('#button-addon2').click
  end

  def then_i_see_results_for_episodes_mentioning_nick_gillespie
    expect(page).to have_content('Nick Gillespie and the Reason Editor Roundtable')
  end


  def when_i_search_for_the_name_nick_gillespie
    visit root_path

    search_input_field = find(:xpath, "/html/body/div[2]/div/div/div[1]/div[1]/input")
    search_input_field.set('Nick Gillespie')
    sleep 2
    find('#button-addon2').click
  end

  def and_i_click_on_on_the_first_search_result
    click_link('Nick Gillespie and the Reason Editor Roundtable')
  end

  def then_i_see_information_about_the_episode_the_term_appeared_in
    expect(page).to have_content('This podcast mentioned Nick Gillespie in an episode')
  end
end
