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

ActiveRecord::Schema.define(version: 2021_11_16_151123) do

  create_table "carts", charset: "utf8mb3", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "order_id", null: false
    t.bigint "food_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_carts_on_food_id"
    t.index ["order_id"], name: "index_carts_on_order_id"
  end

  create_table "categories", charset: "utf8mb3", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorites", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "food_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_favorites_on_food_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "foods", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 10, null: false
    t.text "description"
    t.integer "quantity", null: false
    t.integer "status", default: 0, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_foods_on_category_id"
    t.index ["name"], name: "index_foods_on_name"
    t.index ["price"], name: "index_foods_on_price"
  end

  create_table "orders", charset: "utf8mb3", force: :cascade do |t|
    t.string "phone", null: false
    t.string "address", null: false
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "role", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "carts", "foods"
  add_foreign_key "carts", "orders"
  add_foreign_key "favorites", "foods"
  add_foreign_key "favorites", "users"
  add_foreign_key "foods", "categories"
  add_foreign_key "orders", "users"
end
