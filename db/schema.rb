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

ActiveRecord::Schema[8.0].define(version: 2025_09_08_022359) do
  create_table "demand_forecasts", force: :cascade do |t|
    t.integer "part_id", null: false
    t.integer "warehouse_id", null: false
    t.date "forecast_date", null: false
    t.integer "forecast_quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id", "warehouse_id", "forecast_date"], name: "idx_forecast_uniqueness", unique: true
    t.index ["part_id"], name: "index_demand_forecasts_on_part_id"
    t.index ["warehouse_id"], name: "index_demand_forecasts_on_warehouse_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "quantity"
    t.string "unit_of_measure"
    t.decimal "value"
    t.integer "safe_inventory"
    t.integer "warehouse_id", null: false
    t.integer "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "uom_id"
    t.index ["part_id"], name: "index_inventories_on_part_id"
    t.index ["status"], name: "index_inventories_on_status"
    t.index ["uom_id"], name: "index_inventories_on_uom_id"
    t.index ["warehouse_id"], name: "index_inventories_on_warehouse_id"
  end

  create_table "order_lines", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "part_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.string "unit_of_measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_lines_on_order_id"
    t.index ["part_id"], name: "index_order_lines_on_part_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "purchase_number"
    t.decimal "order_total"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "part_number"
    t.string "name"
    t.string "category"
    t.text "description"
    t.decimal "price"
    t.string "uom"
    t.integer "lead_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true, null: false
    t.integer "uom_id"
    t.index ["is_active"], name: "index_parts_on_is_active"
    t.index ["uom_id"], name: "index_parts_on_uom_id"
  end

  create_table "uoms", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_uoms_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_role", default: 0, null: false
    t.index ["user_role"], name: "index_users_on_user_role"
  end

  create_table "vendor_lead_times", force: :cascade do |t|
    t.integer "vendor_id", null: false
    t.integer "part_id", null: false
    t.integer "expected_lead_time"
    t.integer "actual_lead_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_vendor_lead_times_on_part_id"
    t.index ["vendor_id", "part_id"], name: "index_vendor_lead_times_on_vendor_id_and_part_id", unique: true
    t.index ["vendor_id"], name: "index_vendor_lead_times_on_vendor_id"
  end

  create_table "vendor_part_numbers", force: :cascade do |t|
    t.string "vendor_item"
    t.integer "vendor_id", null: false
    t.integer "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_vendor_part_numbers_on_part_id"
    t.index ["vendor_id"], name: "index_vendor_part_numbers_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "vendor_number"
    t.string "role"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "demand_forecasts", "parts"
  add_foreign_key "demand_forecasts", "warehouses"
  add_foreign_key "inventories", "parts"
  add_foreign_key "inventories", "uoms"
  add_foreign_key "inventories", "warehouses"
  add_foreign_key "order_lines", "orders"
  add_foreign_key "order_lines", "parts"
  add_foreign_key "orders", "users"
  add_foreign_key "vendor_lead_times", "parts"
  add_foreign_key "vendor_lead_times", "vendors"
  add_foreign_key "vendor_part_numbers", "parts"
  add_foreign_key "vendor_part_numbers", "vendors"
end
