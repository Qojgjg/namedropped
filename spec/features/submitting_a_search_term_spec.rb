require 'rails_helper'

RSpec.feature 'submitting a search term' do

  scenario 'submitting a search term and email' do
    when_i_go_to_the_alerts_page
    and_i_enter_a_search_term_and_email
    then_these_are_recorded
    and_i_see_a_confirmation_that_i_will_be_notified
    and_i_receive_a_confirmation_email
  end

  private

  def when_i_go_to_the_alerts_page
    visit alerts_path
  end

  def and_i_enter_a_search_term_and_email
    fill_in('search_term', with: 'Tuple pairing')
    fill_in('email', with: 'email@domain.com')

    click_button('Get notified')
  end

  def then_these_are_recorded
    @user = User.last
    expect(@user.email).to eq('email@domain.com')
    expect(@user.search_terms.last.name).to eq('Tuple pairing')
  end

  def and_i_see_a_confirmation_that_i_will_be_notified
    expect(page).to have_content("Thanks, we'll send you an email when 'Tuple pairing' is namedropped in a podcast.")
  end

  def and_i_receive_a_confirmation_email
    emails_received = ActionMailer::Base.deliveries
    expect(emails_received.last.to).to eq([@user.email])
  end
end

