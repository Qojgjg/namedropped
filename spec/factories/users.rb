FactoryBot.define do
  sequence :user_email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email { FactoryBot.generate(:user_email) }
  end

  trait :admin do
    admin { true }
  end
end
