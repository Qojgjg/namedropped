class CreateSearchTermMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :search_term_matches do |t|
      t.string :matching_episode_field
      t.bigint :episode_id
      t.bigint :search_term_id
      t.timestamps
    end
  end
end
