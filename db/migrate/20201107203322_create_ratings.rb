class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :movie, index: true, foreign_key: true
      t.integer :rating, null: false
      t.text :review

      t.timestamps null: false
    end

    add_index :ratings, [:movie_id, :user_id], unique: true
  end
end
