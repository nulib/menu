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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150721193733) do

  create_table "existing_records", force: :cascade do |t|
    t.string "pid"
    t.string "accession_number"
    t.text   "xml"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "job_id", limit: 8
  end

  create_table "new_records", force: :cascade do |t|
    t.string   "filename"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xml"
    t.string   "proxy_file_name"
    t.string   "proxy_content_type"
    t.integer  "proxy_file_size"
    t.datetime "proxy_updated_at"
    t.string   "image_pid"
    t.string   "work_pid"
    t.integer  "job_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

end
