class CreateSystemMetrics < ActiveRecord::Migration
  def change
    create_table :system_metrics do |t|
      t.datetime :inserted
      t.integer :proc_total
      t.integer :proc_running
      t.integer :proc_stuck
      t.integer :proc_sleeping
      t.integer :proc_threads
      t.float :cpu_user
      t.float :cpu_sys
      t.string :mem_wired
      t.string :mem_active
      t.string :mem_inactive
      t.string :mem_used
      t.integer :net_in_pkt
      t.string :net_in_data
      t.integer :net_out_pkt
      t.string :net_out_data
      t.string :disk_read
      t.string :disk_write
    end
  end
end
