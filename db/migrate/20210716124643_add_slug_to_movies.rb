class AddSlugToMovies < ActiveRecord::Migration[6.1]
  def up
    add_column :movies, :slug, :string
    add_index :movies, :slug, unique: true

    Movie.find_each do |movie|
      movie.send(:generate_slug)
      movie.save!
    end

    change_column_null :movies, :slug, false
  end

  def down
    remove_column :movies, :slug
  end
end
