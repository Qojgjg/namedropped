FactoryBot.define do
  factory :search_term do
    name { 'Tuple pairing' }
    association :user
  end

  trait :with_search_term_match do
    after(:create) do |search_term|
      FactoryBot.create(:search_term_match)
    end
  end
end
