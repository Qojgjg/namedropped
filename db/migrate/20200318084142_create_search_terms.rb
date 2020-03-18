class CreateSearchTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :search_terms do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
