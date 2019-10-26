class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.string :title, null: false
      t.text :description
      t.text :link_to_website
      t.string :guid
      t.timestamp :publication_date
      t.string :enclosure_url
      t.string :enclosure_length
      t.string :enclosure_type
      t.boolean :itunes_explicit
      t.integer :itunes_duration
      t.string :itunes_image
      t.string :itunes_episode_type
      t.belongs_to :podcast
      t.timestamps
    end
  end
end
