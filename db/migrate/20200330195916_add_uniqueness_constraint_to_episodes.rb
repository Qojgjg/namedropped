class AddUniquenessConstraintToEpisodes < ActiveRecord::Migration[6.0]
  def change
    add_index :episodes, [:guid, :podcast_id], unique: true
  end
end
