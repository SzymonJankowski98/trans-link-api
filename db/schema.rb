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

ActiveRecord::Schema[7.0].define(version: 2023_07_17_181219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "learning_texts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id", null: false
    t.string "visibility", default: "public", null: false
    t.string "level", null: false
    t.string "access_key"
    t.boolean "access_key_enabled", default: false, null: false
    t.bigint "base_learning_text_id"
    t.index ["base_learning_text_id"], name: "index_learning_texts_on_base_learning_text_id"
    t.index ["language_id"], name: "index_learning_texts_on_language_id"
    t.index ["user_id"], name: "index_learning_texts_on_user_id"
  end

  create_table "sentences", force: :cascade do |t|
    t.integer "order"
    t.bigint "learning_text_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learning_text_id"], name: "index_sentences_on_learning_text_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "learning_texts", "languages"
  add_foreign_key "learning_texts", "learning_texts", column: "base_learning_text_id"
  add_foreign_key "learning_texts", "users"
  add_foreign_key "sentences", "learning_texts"
end
