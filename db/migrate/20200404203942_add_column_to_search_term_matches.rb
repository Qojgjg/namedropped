class AddColumnToSearchTermMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :search_term_matches, :notified_on, :datetime
  end
end
