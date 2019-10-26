class Category < ApplicationRecord
  has_many :podcast_categories
  has_many :podcasts, through: :podcast_categories

  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
end
