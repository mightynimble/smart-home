class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :password
      t.string :email
      t.integer :access_level

      t.timestamps
    end
  end
end
