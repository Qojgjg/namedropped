class SearchTerm < ApplicationRecord
  belongs_to :user
  has_many :search_term_matches
  validates :name, presence: true

  scope :with_matches_due_for_notification, -> { joins(:search_term_matches).where('search_terms.created_at < ?', Date.today).where('search_term_matches.notified_on IS ?', nil).distinct }
end
