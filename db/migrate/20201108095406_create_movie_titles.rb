class CreateMovieTitles < ActiveRecord::Migration
  def change
    create_table :movie_titles do |t|
      t.belongs_to :movie, index: true, foreign_key: true
      t.string :title, null: false
      t.datetime :created_at, null: false
    end
  end
end
