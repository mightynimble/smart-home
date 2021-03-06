# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130720154940) do

  create_table "system_metrics", :force => true do |t|
    t.datetime "inserted"
    t.integer  "proc_total"
    t.integer  "proc_running"
    t.integer  "proc_stuck"
    t.integer  "proc_sleeping"
    t.integer  "proc_threads"
    t.float    "cpu_user"
    t.float    "cpu_sys"
    t.string   "mem_wired"
    t.string   "mem_active"
    t.string   "mem_inactive"
    t.string   "mem_used"
    t.integer  "net_in_pkt"
    t.string   "net_in_data"
    t.integer  "net_out_pkt"
    t.string   "net_out_data"
    t.string   "disk_read"
    t.string   "disk_write"
  end

  add_index "system_metrics", ["inserted"], :name => "index_system_metrics_on_inserted"

  create_table "temperatures", :force => true do |t|
    t.string   "device",      :limit => 80, :null => false
    t.integer  "temperature",               :null => false
    t.datetime "inserted",                  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "password"
    t.string   "email"
    t.integer  "access_level"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
