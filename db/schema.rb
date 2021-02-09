# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

 teams-and-managers
ActiveRecord::Schema.define(version: 2021_02_09_042930) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "managers", force: :cascade do |t|
    t.string "watiam", limit: 50, null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "manager_id", null: false
    t.string "password", null: false
    t.index ["manager_id"], name: "index_managers_on_manager_id", unique: true
  end

  create_table "managers_teams", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "manager_id", null: false
    t.index ["team_id", "manager_id"], name: "index_managers_teams_on_team_id_and_manager_id", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.integer "survey_id", null: false
    t.integer "question_number", null: false
    t.integer "response", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.date "date"
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_surveys_on_team_id"
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "watiam", limit: 50, null: false
    t.integer "user_id", null: false
    t.string "password", limit: 100, null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "surveys", "teams"
  add_foreign_key "surveys", "users"
  add_foreign_key "teams_users", "teams"
  add_foreign_key "teams_users", "users"
end
