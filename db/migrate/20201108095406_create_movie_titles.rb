class CreateMovieTitles < ActiveRecord::Migration[4.2]
  def change
    create_table :movie_titles do |t|
      t.belongs_to :movie, index: true, foreign_key: true
      t.string :title, null: false
      t.datetime :created_at, null: false
    end
  end
end
