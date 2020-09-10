class AddPlayerStatTable < ActiveRecord::Migration[5.1]
  def change
    create_table :player_stats do |t|
      t.string :player_id
      t.string :team_id
      t.string :season
      t.string :week
      t.string :projected_total
      t.string :actual_total
      t.timestamps
    end
  end
end
