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

ActiveRecord::Schema.define(:version => 20121126095018) do

  create_table "assets", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "message_id"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "flag_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "content"
    t.integer  "parent_id"
    t.boolean  "flagged",    :default => false
    t.integer  "sender_id"
    t.string   "subject"
  end

  create_table "oauths", :force => true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "receivers", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.integer  "status"
    t.boolean  "read"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "threadmessages", :force => true do |t|
    t.text     "description"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "message_id"
    t.integer  "draft"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "age"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "password_digest"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "notification"
    t.string   "time_zone"
  end

end
