class CreatePodcastCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :podcast_categories do |t|
      t.belongs_to :podcast
      t.belongs_to :category
    end
  end
end
