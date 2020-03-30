class SearchTermMatch < ApplicationRecord
  belongs_to :episode
  belongs_to :search_term
  belongs_to :user
end
