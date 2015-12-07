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

ActiveRecord::Schema.define(version: 20140109224100) do

  create_table "interventions", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "abbrev"
    t.text     "benefit"
    t.integer  "principle_id"
    t.string   "tracks"
    t.text     "regimen"
    t.text     "alternate_options"
    t.string   "maintenance_dose"
    t.text     "safety_precautions"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interventions", ["principle_id"], name: "index_interventions_on_principle_id"

  create_table "tagphotos", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
