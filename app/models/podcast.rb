class Podcast < ApplicationRecord
  validates :title, presence: true
  validates :rss, presence: true
  validates :itunes_id, uniqueness: true

  has_many :episodes
  has_many :podcast_categories
  has_many :categories, through: :podcast_categories
end
