class SearchTermMatch < ApplicationRecord
  belongs_to :episode
  belongs_to :search_term
  belongs_to :user

  validates_uniqueness_of :search_term_id, scope: [:episode_id, :user_id]

  scope :due_for_notification, -> { joins(:search_term).where(notified_on: nil).where("search_terms.created_at < ?", Date.today) }
  scope :notified, -> { where.not(notified_on: nil) }
end
