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

ActiveRecord::Schema.define(version: 20160316044837) do

  create_table "blogs", force: :cascade do |t|
    t.text    "url"
    t.boolean "completed",                               default: false
    t.decimal "simpson_index", precision: 10, scale: 10
  end

  create_table "comparisons", force: :cascade do |t|
    t.integer "first_blog_id"
    t.integer "second_blog_id"
    t.decimal "overlap",        precision: 10, scale: 10
  end

  create_table "posts", force: :cascade do |t|
    t.integer "blog_id"
    t.integer "post_id",      limit: 8
    t.text    "post_url"
    t.text    "source_title"
    t.integer "note_count"
    t.text    "date"
    t.text    "post_type"
    t.integer "is_reblogged"
    t.integer "timestamp",    limit: 8
  end

end
