class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.string :component
      t.decimal :temperature

      t.timestamps
    end
  end
end
