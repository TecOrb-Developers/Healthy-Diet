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

ActiveRecord::Schema.define(version: 20141106121330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "device_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "diseases", force: true do |t|
    t.string  "name",                           null: false
    t.boolean "track_history",  default: false, null: false
    t.boolean "track_medicine", default: false, null: false
  end

  create_table "intervention_trials", force: true do |t|
    t.integer  "user_id"
    t.integer  "intervention_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "intervention_trials_bak", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "user_id"
    t.integer  "intervention_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "intervention_types", force: true do |t|
    t.string "name", null: false
  end

  create_table "intervention_uses", force: true do |t|
    t.integer  "intervention_trial_id",                 null: false
    t.datetime "on_date",                               null: false
    t.boolean  "taken"
    t.integer  "user_id"
    t.integer  "intervention_id"
    t.integer  "trial_id"
    t.boolean  "pending",               default: false
  end

  add_index "intervention_uses", ["intervention_id"], name: "index_intervention_uses_on_intervention_id", using: :btree
  add_index "intervention_uses", ["trial_id"], name: "index_intervention_uses_on_trial_id", using: :btree
  add_index "intervention_uses", ["user_id"], name: "index_intervention_uses_on_user_id", using: :btree

  create_table "intervention_uses_bak", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "intervention_trial_id"
    t.datetime "on_date"
    t.boolean  "taken"
    t.integer  "user_id"
    t.integer  "intervention_id"
    t.integer  "trial_id"
  end

  create_table "interventions", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "abbrev"
    t.text     "benefit"
    t.integer  "principle_id"
    t.string   "tracks"
    t.text     "regimen"
    t.text     "alternate_options"
    t.text     "maintenance_dose"
    t.text     "safety_precautions"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interventions", ["principle_id"], name: "index_interventions_on_principle_id", using: :btree

  create_table "interventions_contraindications", force: true do |t|
    t.integer "intervention_id", null: false
    t.integer "disease_id",      null: false
  end

  create_table "interventions_diseases", force: true do |t|
    t.integer "intervention_id", null: false
    t.integer "disease_id",      null: false
  end

  create_table "pages", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "principles", force: true do |t|
    t.string "name",        null: false
    t.text   "description"
  end

  create_table "principles_interventions", force: true do |t|
    t.integer "principles_id"
    t.integer "interventions_id"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "gender"
    t.integer  "age"
    t.string   "ethnicity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagphotos", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: true do |t|
    t.integer "disease_id", null: false
    t.string  "name",       null: false
  end

  create_table "trials", id: false, force: true do |t|
    t.integer "id",         null: false
    t.date    "start_date", null: false
    t.date    "end_date"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "settings",               default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_histories", id: false, force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "disease_id",   null: false
    t.string   "history_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_tracks", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "track_id", null: false
  end

  create_table "users_trials", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "trial_id", null: false
  end

  create_table "users_trials_1", id: false, force: true do |t|
    t.integer "id"
    t.integer "user_id"
    t.integer "trial_id"
  end

  create_table "users_variables", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "variable_id", null: false
    t.float    "value",       null: false
    t.float    "value2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variables", force: true do |t|
    t.string  "variable_type"
    t.string  "name",                      null: false
    t.string  "unit"
    t.integer "precision",     default: 0, null: false
    t.string  "value_type",                null: false
    t.string  "low"
    t.string  "high"
    t.string  "ideal"
  end

  create_table "variables_diseases", force: true do |t|
    t.integer "variable_id", null: false
    t.integer "disease_id",  null: false
  end

end
