FactoryBot.define do
  sequence :itunes_id

  factory :podcast do
    title { "Reason Editors Roundtable" }
    rss  { "rss-feed-address.com" }
    itunes_id { FactoryBot.generate(:itunes_id) }
  end
end
