# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_27_083225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

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
    t.index ["guid"], name: "index_episodes_on_guid"
    t.index ["id"], name: "index_episodes_on_id"
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
    t.string "itunes_image"
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
    t.integer "rating_count"
    t.float "average_rating"
    t.integer "itunes_id"
    t.index ["itunes_id"], name: "index_podcasts_on_itunes_id", unique: true
  end

  create_table "search_term_matches", force: :cascade do |t|
    t.string "matching_episode_field"
    t.bigint "episode_id"
    t.bigint "search_term_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "search_terms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_search_terms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "search_terms", "users"
end
