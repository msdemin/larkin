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

ActiveRecord::Schema.define(version: 20160727184626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_number"
    t.string   "phone_ext"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "csv_imports", force: :cascade do |t|
    t.text     "csv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "client_id"
    t.decimal  "volume",     precision: 7, scale: 2
    t.integer  "quantity"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "orders", ["client_id"], name: "index_orders_on_client_id", using: :btree

  create_table "test_data", force: :cascade do |t|
    t.text    "delivery_date"
    t.text    "delivery_shift"
    t.text    "origin_name"
    t.text    "origin_raw_line_1"
    t.text    "origin_city"
    t.text    "origin_state"
    t.text    "origin_zip"
    t.text    "origin_country"
    t.text    "client_name"
    t.text    "destination_raw_line_1"
    t.text    "destination_city"
    t.text    "destination_state"
    t.text    "destination_zip"
    t.text    "destination_country"
    t.text    "phone_number"
    t.text    "mode"
    t.text    "purchase_order_number"
    t.decimal "volume",                 precision: 7, scale: 2
    t.integer "handling_unit_quantity"
    t.text    "handling_unit_type"
  end

  create_table "ttt", id: :bigserial, force: :cascade do |t|
    t.string "name", limit: 256, array: true
  end

  add_foreign_key "orders", "clients"
end
