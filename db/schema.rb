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

ActiveRecord::Schema.define(version: 20180604232341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_loans", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status"
    t.decimal "opening_balance"
    t.integer "loan_term"
    t.text "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.decimal "interest_rate"
    t.decimal "periodic_repayment_amount"
    t.decimal "repayment_capacity"
    t.string "employment_type"
    t.integer "work_gap_months"
    t.index ["user_id"], name: "index_active_loans_on_user_id"
  end

  create_table "charts", force: :cascade do |t|
    t.string "chart"
    t.text "project_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row_spacing"
    t.hstore "rows", default: [], array: true
    t.integer "container_width"
    t.bigint "start_date"
    t.bigint "end_date"
  end

  create_table "employment_types", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investments", force: :cascade do |t|
    t.bigint "active_loan_id"
    t.bigint "user_id"
    t.decimal "opening_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "repayment_amount"
    t.index ["active_loan_id"], name: "index_investments_on_active_loan_id"
    t.index ["user_id"], name: "index_investments_on_user_id"
  end

  create_table "loan_applications", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "loan_amount"
    t.integer "loan_term"
    t.text "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "first_name"
    t.string "last_name"
    t.bigint "loan_category_id"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.integer "postcode"
    t.bigint "employment_type_id"
    t.decimal "weekly_income"
    t.decimal "weekly_expenses"
    t.integer "work_gap_months"
    t.text "pay_slip_data"
    t.text "license_data"
    t.index ["employment_type_id"], name: "index_loan_applications_on_employment_type_id"
    t.index ["loan_category_id"], name: "index_loan_applications_on_loan_category_id"
    t.index ["user_id"], name: "index_loan_applications_on_user_id"
  end

  create_table "loan_categories", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "repayments", force: :cascade do |t|
    t.bigint "active_loan_id"
    t.bigint "investment_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_loan_id"], name: "index_repayments_on_active_loan_id"
    t.index ["investment_id"], name: "index_repayments_on_investment_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount"
    t.integer "from_account_id"
    t.integer "to_account_id"
    t.decimal "from_account_balance"
    t.decimal "to_account_balance"
    t.string "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_loans", "users"
  add_foreign_key "investments", "active_loans"
  add_foreign_key "investments", "users"
  add_foreign_key "loan_applications", "users"
  add_foreign_key "portfolios", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "repayments", "active_loans"
  add_foreign_key "repayments", "investments"
end
