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

ActiveRecord::Schema.define(:version => 20120809133850) do

  create_table "group_children", :force => true do |t|
    t.string   "value"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_children", ["group_id"], :name => "index_group_children_on_group_id"

  create_table "group_parents", :force => true do |t|
    t.string   "value"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_parents", ["group_id"], :name => "index_group_parents_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "search_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ldap_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "search_errors", :force => true do |t|
    t.text     "value"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "search_results", :force => true do |t|
    t.text     "value"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "searches", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name"
    t.boolean  "temp",          :default => false
    t.text     "email_message"
  end

  create_table "user_emails", :force => true do |t|
    t.string   "email"
    t.integer  "search_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
