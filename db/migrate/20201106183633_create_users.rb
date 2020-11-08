class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :remember_token
      t.datetime :remember_created_at
      t.boolean :admin, null: false, default: false
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, [:uid, :provider], unique: true
  end
end
