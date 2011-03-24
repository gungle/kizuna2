# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101105095513) do

  create_table "accesses", :force => true do |t|
    t.integer  "access_kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devicetokens", :force => true do |t|
    t.integer  "personal_id"
    t.string   "device_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disastermemos", :force => true do |t|
    t.integer  "personal_id"
    t.string   "disaster_memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disasters", :force => true do |t|
    t.integer  "personal_id"
    t.integer  "group_id"
    t.integer  "emergency_kind"
    t.integer  "disaster_status_kind"
    t.integer  "triage_kind"
    t.integer  "done_kind"
    t.float    "now_lat"
    t.float    "now_lon"
    t.string   "picture_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "disaster_memo"
  end

  create_table "families", :force => true do |t|
    t.integer  "group_id"
    t.string   "family_name"
    t.string   "address"
    t.string   "home_tel"
    t.float    "home_lat"
    t.float    "home_lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "share_disaster_kind"
  end

  create_table "logins", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modes", :force => true do |t|
    t.integer  "mode_kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personals", :force => true do |t|
    t.integer  "group_id"
    t.integer  "family_id"
    t.string   "login"
    t.string   "password"
    t.string   "full_name"
    t.datetime "birthday"
    t.integer  "sex"
    t.integer  "blood"
    t.integer  "weak_kind"
    t.string   "personal_tel"
    t.string   "job"
    t.text     "good_field"
    t.text     "medical_history"
    t.string   "icon_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalsafeties", :force => true do |t|
    t.integer  "personal_id"
    t.integer  "group_id"
    t.integer  "family_id"
    t.integer  "personal_safety_kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.integer  "group_id"
    t.integer  "place_kind"
    t.string   "place_title"
    t.text     "place_explain"
    t.float    "place_lat"
    t.float    "place_lon"
    t.string   "picture_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
