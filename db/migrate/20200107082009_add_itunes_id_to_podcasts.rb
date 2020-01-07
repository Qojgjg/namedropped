class AddItunesIdToPodcasts < ActiveRecord::Migration[5.2]
  def change
    add_column :podcasts, :itunes_id, :integer
    add_index :podcasts, :itunes_id, unique: true
  end
end
