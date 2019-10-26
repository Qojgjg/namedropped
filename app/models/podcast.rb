class Podcast < ApplicationRecord
  validates :title, presence: true
  validates :itunes_image, presence: true
  validates :rss, presence: true
end
