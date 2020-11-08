class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :original_title, null: false
      t.string :original_language, null: false
      t.string :imdb_id, null: false
      t.integer :tmdb_id, null: false
      t.string :overview
      t.string :tmdb_poster_path
      t.string :omdb_poster_url
      t.date :released_on, null: false
      t.float :average_rating, null: false, default: 0
      t.integer :ratings_count, null: false, default: 0
      t.string :mpaa_rating
      t.timestamps null: false
      t.integer :creator_id, null: false
    end

    add_index :movies, :imdb_id, unique: true
    add_index :movies, :tmdb_id, unique: true
  end
end
