require 'rails_helper'

RSpec.feature 'interacting with search' do

  background do
    Episode.create(title: 'Nick Gillespie and the Reason Editor Roundtable',
                   description: 'Discussing the week events'
                  )
  end

  scenario 'searching for a person', js: true, elasticsearch: true do
    when_i_visit_the_homepage
    and_i_search_for_the_name_nick_gillespie
    then_i_see_results_for_episodes_mentioning_nick_gillespie
  end

  private

  def when_i_visit_the_homepage
    visit root_path
  end

  def and_i_search_for_the_name_nick_gillespie
    search_input_field = find(:xpath, "/html/body/div[2]/div/div/div[1]/div[1]/input")
    search_input_field.set('Nick Gillespie')
  end

  def then_i_see_results_for_episodes_mentioning_nick_gillespie
    expect(page).to have_content('Nick Gillespie and the Reason Editor Roundtable')
  end
end
