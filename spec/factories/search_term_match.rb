FactoryBot.define do
  factory :search_term_match do
    association :user
    search_term
    episode
  end

  trait :notified do
    after(:create) do |search_term_match|
      search_term_match.update(notified_on: DateTime.now)
    end
  end
end
