class AddSeasonStatsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :season_stats do |t|
      t.string :team_id
      t.string :season
      t.string :playoff_seed
      t.string :final_espn_rank
      t.timestamps
    end
  end
end
