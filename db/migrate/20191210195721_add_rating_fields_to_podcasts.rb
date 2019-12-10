class AddRatingFieldsToPodcasts < ActiveRecord::Migration[5.2]
  def change
    add_column :podcasts, :rating_count, :integer
    add_column :podcasts, :average_rating, :float
  end
end
