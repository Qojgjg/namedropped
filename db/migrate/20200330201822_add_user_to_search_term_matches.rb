class AddUserToSearchTermMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :search_term_matches, :user_id, :bigint
  end
end
