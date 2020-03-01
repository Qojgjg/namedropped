FactoryBot.define do
  factory :episode do
    title { "Nick Gillespie and the Reason Editor Roundtable" }
    description { "Discussing the week events" }
    podcast
    publication_date { DateTime.now }
  end
end
