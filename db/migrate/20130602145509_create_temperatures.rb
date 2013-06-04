class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.string :device,       :limit => 80, :null => false
      t.integer :temperature, :null => false
      t.datetime :inserted,   :null => false
    end
  end
end
