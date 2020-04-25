require 'rails_helper'

RSpec.feature 'interacting with admin pages' do
  scenario 'accessing the admin path' do
    as_a_signed_out_user
    when_i_visit_the_admin_path
    then_i_am_redirected_to_the_sign_in_path
  end

  scenario 'signing in as an admin' do
    when_i_visit_the_sign_in_path
    and_i_sign_in_as_an_admin
    then_i_see_that_i_signed_in_sucessfully
    and_i_can_access_the_admin_path
  end

  private

  def as_a_signed_out_user
  end

  def when_i_visit_the_admin_path
    visit sidekiq_web_path
  end

  def then_i_am_redirected_to_the_sign_in_path
    expect(page).to have_content('Please sign in')
  end

  def when_i_visit_the_sign_in_path
    FactoryBot.create(:user, :admin, email: 'admin@namedropped.co', password: 'my_secret_password')
    visit new_user_session_path
  end

  def and_i_sign_in_as_an_admin
    fill_in('user_email', with: 'admin@namedropped.co')
    fill_in('user_password', with: 'my_secret_password')

    click_button('Log in')
  end

  def then_i_see_that_i_signed_in_sucessfully
    expect(page).to have_content('Signed in successfully.')
  end

  def and_i_can_access_the_admin_path
    visit sidekiq_web_path
    expect(page).to have_content('Enqueued')
  end
end
