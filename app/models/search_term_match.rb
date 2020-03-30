class SearchTermMatch < ApplicationRecord
  belongs_to :episode
  belongs_to :search_term
  belongs_to :user

  validates_uniqueness_of :search_term_id, scope: [:episode_id, :user_id]
end
