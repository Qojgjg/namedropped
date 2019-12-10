class MakeItunesImageNotRequired < ActiveRecord::Migration[5.2]
  def change
    change_column :podcasts, :itunes_image, :string, null: true
  end
end
