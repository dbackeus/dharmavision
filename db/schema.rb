# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20201108095406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "movie_titles", force: :cascade do |t|
    t.integer  "movie_id"
    t.string   "title",      null: false
    t.datetime "created_at", null: false
  end

  add_index "movie_titles", ["movie_id"], name: "index_movie_titles_on_movie_id", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",                           null: false
    t.string   "original_title",                  null: false
    t.string   "original_language",               null: false
    t.string   "imdb_id",                         null: false
    t.integer  "tmdb_id",                         null: false
    t.string   "overview"
    t.string   "tmdb_poster_path"
    t.string   "omdb_poster_url"
    t.date     "released_on",                     null: false
    t.float    "average_rating",    default: 0.0, null: false
    t.integer  "ratings_count",     default: 0,   null: false
    t.string   "mpaa_rating"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "creator_id",                      null: false
  end

  add_index "movies", ["imdb_id"], name: "index_movies_on_imdb_id", unique: true, using: :btree
  add_index "movies", ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true, using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.integer  "rating",     null: false
    t.text     "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["movie_id", "user_id"], name: "index_ratings_on_movie_id_and_user_id", unique: true, using: :btree
  add_index "ratings", ["movie_id"], name: "index_ratings_on_movie_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "email",                               null: false
    t.string   "provider",                            null: false
    t.string   "uid",                                 null: false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.boolean  "admin",               default: false, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "movie_titles", "movies"
  add_foreign_key "ratings", "movies"
  add_foreign_key "ratings", "users"
end
