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

ActiveRecord::Schema.define(version: 20140912123701) do

  create_table "environments", force: true do |t|
    t.text     "riskapi"
    t.text     "pds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "queries", force: true do |t|
    t.string   "method"
    t.text     "url"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: true do |t|
    t.integer  "environment_id"
    t.integer  "suite_id"
    t.text     "results"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suites", force: true do |t|
    t.text     "name"
    t.text     "tests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "systems", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.text     "name"
    t.text     "queries"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
