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

ActiveRecord::Schema[7.0].define(version: 2022_12_16_173951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "account_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "payment_type", default: 0
    t.string "payment_id", limit: 30
    t.bigint "bank_id"
    t.bigint "party_id"
    t.decimal "amount"
    t.decimal "transaction_cost"
    t.datetime "transaction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "payment_id"], name: "index_payments_on_user_id_and_payment_id", unique: true
  end

  create_table "texts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "bank_id"
    t.string "message"
    t.string "message_hash"
    t.datetime "message_date", default: "2022-12-16 23:48:21"
    t.boolean "is_processed"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_hash"], name: "index_texts_on_message_hash", unique: true
  end

  create_table "transaction_joins", force: :cascade do |t|
    t.bigint "payment_id"
    t.bigint "transaction_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_types", force: :cascade do |t|
    t.bigint "bank_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "identity_url"
    t.string "sid"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
