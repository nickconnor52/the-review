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

ActiveRecord::Schema.define(version: 20200910002153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: :cascade do |t|
    t.string "player_id"
    t.string "team_id"
    t.string "draft_id"
    t.string "round_number"
    t.string "round_pick_number"
    t.string "overall_pick_number"
    t.string "original_pick_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drafts", force: :cascade do |t|
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string "away_team_id"
    t.string "home_team_id"
    t.string "away_score"
    t.string "home_score"
    t.string "season"
    t.string "week"
    t.string "winner"
    t.string "playoff_tier_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "city", null: false
    t.string "season_joined", null: false
    t.string "last_active_season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_id"
    t.string "espn_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "full_name", null: false
    t.string "espn_id", null: false
    t.string "espn_fantasy_team_id"
    t.string "team_id"
    t.string "espn_pro_team_id", null: false
    t.string "pro_team_id"
    t.string "espn_position_id"
    t.string "position_id"
    t.string "jersey_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players_rosters", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "roster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_players_rosters_on_player_id"
    t.index ["roster_id"], name: "index_players_rosters_on_roster_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.text "summary"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "pro_teams", force: :cascade do |t|
    t.string "espn_id", null: false
    t.string "name", null: false
    t.string "nickname", null: false
    t.string "abbreviation"
    t.string "logo_url"
    t.string "conference_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rosters", force: :cascade do |t|
    t.string "team_id"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_identifiers", force: :cascade do |t|
    t.string "team_id", null: false
    t.string "location", null: false
    t.string "nickname", null: false
    t.string "abbreviation", null: false
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "espn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_pieces", force: :cascade do |t|
    t.string "from_team_id"
    t.string "to_team_id"
    t.string "player_id"
    t.string "draft_pick_id"
    t.string "action_type"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "espn_id", null: false
    t.string "accepted_date"
    t.string "transaction_type"
    t.string "bid_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "players_rosters", "players"
  add_foreign_key "players_rosters", "rosters"
  add_foreign_key "posts", "users"
end
