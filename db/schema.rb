# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_26_215153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "link_to_website"
    t.string "guid"
    t.datetime "publication_date"
    t.string "enclosure_url"
    t.string "enclosure_length"
    t.string "enclosure_type"
    t.boolean "itunes_explicit"
    t.integer "itunes_duration"
    t.string "itunes_image"
    t.string "itunes_episode_type"
    t.bigint "podcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
  end

  create_table "podcast_categories", force: :cascade do |t|
    t.bigint "podcast_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_podcast_categories_on_category_id"
    t.index ["podcast_id"], name: "index_podcast_categories_on_podcast_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "language"
    t.string "website"
    t.string "rss", null: false
    t.string "country"
    t.string "itunes_image", null: false
    t.boolean "itunes_explicit"
    t.boolean "itunes_complete"
    t.string "itunes_author"
    t.string "itunes_owner_name"
    t.string "itunes_owner_email"
    t.string "itunes_type"
    t.string "itunes_subtitle"
    t.string "itunes_summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "categories", column: "parent_id"
end
