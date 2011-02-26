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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110226205759) do

  create_table "players", :force => true do |t|
    t.integer  "playerId"
    t.string   "name"
    t.boolean  "alive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team"
    t.boolean  "current",    :default => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "playerId"
    t.integer  "gameId"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "player0"
    t.integer  "player1"
    t.integer  "player2"
    t.integer  "player3"
    t.integer  "player4"
    t.integer  "player5"
    t.integer  "player6"
    t.integer  "player7"
    t.integer  "player8"
    t.integer  "player9"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
