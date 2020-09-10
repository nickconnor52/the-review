class AddGamesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :away_team_id
      t.string :home_team_id
      t.string :away_score
      t.string :home_score
      t.string :season
      t.string :week
      t.string :winner
      t.string :playoff_tier_type
      t.timestamps
    end
  end
end
