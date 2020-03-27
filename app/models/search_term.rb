class SearchTerm < ApplicationRecord
  belongs_to :user
  has_many :search_term_matches
  validates :name, presence: true
end
