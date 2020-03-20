class AddIndexToEpisodes < ActiveRecord::Migration[6.0]
  def change
    add_index :episodes, :id
  end
end
