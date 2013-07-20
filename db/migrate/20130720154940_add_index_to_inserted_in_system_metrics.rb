class AddIndexToInsertedInSystemMetrics < ActiveRecord::Migration
  def change
    add_index :system_metrics, :inserted
  end
end
