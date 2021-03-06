# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_16_124643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "movie_titles", force: :cascade do |t|
    t.integer "movie_id"
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.index ["movie_id"], name: "index_movie_titles_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.string "original_title", null: false
    t.string "original_language", null: false
    t.string "imdb_id", null: false
    t.integer "tmdb_id", null: false
    t.string "overview"
    t.string "tmdb_poster_path"
    t.string "omdb_poster_url"
    t.date "released_on", null: false
    t.float "average_rating", default: 0.0, null: false
    t.integer "ratings_count", default: 0, null: false
    t.string "mpaa_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id", null: false
    t.string "slug", null: false
    t.index ["imdb_id"], name: "index_movies_on_imdb_id", unique: true
    t.index ["slug"], name: "index_movies_on_slug", unique: true
    t.index ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "movie_id"
    t.integer "rating", null: false
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "user_id"], name: "index_ratings_on_movie_id_and_user_id", unique: true
    t.index ["movie_id"], name: "index_ratings_on_movie_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "remember_token"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "movie_titles", "movies"
  add_foreign_key "ratings", "movies"
  add_foreign_key "ratings", "users"
end
