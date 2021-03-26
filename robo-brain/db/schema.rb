# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 3) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assembly", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.uuid "car_serial_num", null: false
    t.integer "component_id", null: false
    t.uuid "component_serial_num", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.boolean "failed"
  end

  create_table "car", id: :serial, force: :cascade do |t|
    t.uuid "serial_num", null: false
    t.bigint "model_id", null: false
    t.bigint "warehouse_id"
    t.text "stage"
    t.text "status"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.index ["model_id"], name: "index_car_on_model_id"
    t.index ["serial_num"], name: "unq_serial_num", unique: true
    t.index ["warehouse_id"], name: "index_car_on_warehouse_id"
  end

  create_table "component", force: :cascade do |t|
    t.text "category", null: false
    t.text "name", null: false
    t.text "description", null: false
    t.money "price_cost", scale: 2, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
  end

  create_table "model", force: :cascade do |t|
    t.text "name", null: false
    t.decimal "revenue_factor", precision: 2, scale: 2, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
  end

  create_table "model_specification", force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "component_id", null: false
    t.integer "qty", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.index ["model_id", "component_id"], name: "unq_model_component", unique: true
  end

  create_table "purchase", force: :cascade do |t|
    t.text "buyer", null: false
    t.bigint "requisition_id", null: false
    t.uuid "car_sn", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.index ["requisition_id"], name: "index_purchase_on_requisition_id"
  end

  create_table "requisition", force: :cascade do |t|
    t.text "requester", null: false
    t.bigint "model_id", null: false
    t.text "status", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.index ["model_id"], name: "index_requisition_on_model_id"
  end

  create_table "warehouse", force: :cascade do |t|
    t.text "name", null: false
    t.text "location", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
  end

  add_foreign_key "assembly", "car", column: "car_serial_num", primary_key: "serial_num", name: "fk_assembly_car"
  add_foreign_key "assembly", "component", name: "fk_assembly_component"
  add_foreign_key "car", "model", name: "fk_car_model"
  add_foreign_key "car", "warehouse", name: "fk_car_warehouse"
  add_foreign_key "model_specification", "component", name: "fk_model_specification_component"
  add_foreign_key "model_specification", "model", name: "fk_model_specification_model"
  add_foreign_key "purchase", "car", column: "car_sn", primary_key: "serial_num", name: "fk_purchase_car"
  add_foreign_key "purchase", "requisition", name: "fk_purchase_requisition"
  add_foreign_key "requisition", "model", name: "fk_requisition_model"
end
