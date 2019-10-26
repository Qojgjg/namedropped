class Category < ApplicationRecord
  has_many :podcast_categories
  has_many :podcasts, through: :podcast_categories
end
