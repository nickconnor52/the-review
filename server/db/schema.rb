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

ActiveRecord::Schema.define(version: 20210902211345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.string "user_id"
    t.string "parent_comment_id"
    t.string "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.float "home_best_ball_score"
    t.float "away_best_ball_score"
    t.string "sleeper_matchup_id"
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
    t.string "sleeper_id"
  end

  create_table "player_stats", force: :cascade do |t|
    t.string "player_id"
    t.string "team_id"
    t.string "season"
    t.string "week"
    t.string "projected_total"
    t.string "actual_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "full_name", null: false
    t.string "espn_id"
    t.string "espn_fantasy_team_id"
    t.string "team_id"
    t.string "espn_pro_team_id"
    t.string "pro_team_id"
    t.string "espn_position_id"
    t.string "position_id"
    t.string "jersey_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "on_trade_block", default: false
    t.string "sleeper_id"
    t.string "sleeper_position_id"
    t.string "sleeper_pro_team_id"
    t.string "sleeper_fantasy_team_id"
  end

  create_table "players_rosters", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "roster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_players_rosters_on_player_id"
    t.index ["roster_id"], name: "index_players_rosters_on_roster_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "espn_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sleeper_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.text "summary"
    t.string "post_type", default: "chatter"
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
    t.string "sleeper_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.string "team_id"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "season_stats", force: :cascade do |t|
    t.string "team_id"
    t.string "season"
    t.string "playoff_seed"
    t.string "final_espn_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_identifiers", force: :cascade do |t|
    t.string "team_id", null: false
    t.string "location"
    t.string "nickname", null: false
    t.string "abbreviation"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "espn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.datetime "trade_block_updated_at"
    t.string "trade_block_position_id", default: "0"
    t.string "sleeper_id"
    t.string "sleeper_roster_id"
  end

  create_table "teams_transactions", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_teams_transactions_on_team_id"
    t.index ["transaction_id"], name: "index_teams_transactions_on_transaction_id"
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
    t.string "espn_id"
    t.string "accepted_date"
    t.string "transaction_type"
    t.string "bid_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.string "sleeper_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "username"
  end

  add_foreign_key "players_rosters", "players"
  add_foreign_key "players_rosters", "rosters"
  add_foreign_key "posts", "users"
  add_foreign_key "teams_transactions", "teams"
  add_foreign_key "teams_transactions", "transactions"
end
