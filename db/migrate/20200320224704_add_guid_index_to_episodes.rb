class AddGuidIndexToEpisodes < ActiveRecord::Migration[6.0]
  def change
    add_index :episodes, :guid
  end
end
