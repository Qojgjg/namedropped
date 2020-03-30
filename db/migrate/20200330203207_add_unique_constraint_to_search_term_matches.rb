class AddUniqueConstraintToSearchTermMatches < ActiveRecord::Migration[6.0]
  def change
    add_index :search_term_matches, [:episode_id, :search_term_id, :user_id], unique: true, name: 'custom_uniqueness_index'
  end
end
