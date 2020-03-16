require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates an email address is present' do
    user = User.create
    expect(user).not_to be_valid
  end
end
