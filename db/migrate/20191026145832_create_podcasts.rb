class CreatePodcasts < ActiveRecord::Migration[5.2]
  def change
    create_table :podcasts do |t|
      t.string :title, null: false
      t.text :description
      t.string :language
      t.string :website
      t.string :rss, null: false
      t.string :country
      t.string :itunes_image, null: false
      t.boolean :itunes_explicit
      t.boolean :itunes_complete
      t.string :itunes_author
      t.string :itunes_owner_name
      t.string :itunes_owner_email
      t.string :itunes_type
      t.string :itunes_subtitle
      t.string :itunes_summary
      t.timestamps
    end
  end
end
