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

ActiveRecord::Schema.define(:version => 20130725280000) do

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reservations", :force => true do |t|
    t.string   "user_onid"
    t.integer  "room_id"
    t.string   "reserver_onid"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "reservations", ["room_id"], :name => "index_reservations_on_room_id_id"

  create_table "room_filters", :force => true do |t|
    t.integer  "room_id"
    t.integer  "filter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "room_filters", ["filter_id"], :name => "index_room_filters_on_filter_id"
  add_index "room_filters", ["room_id"], :name => "index_room_filters_on_room_id"

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "floor"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
