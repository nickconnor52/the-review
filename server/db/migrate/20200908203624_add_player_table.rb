class AddPlayerTable < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :full_name, null: false
      t.string :espn_id, null: false
      t.string :espn_fantasy_team_id
      t.string :team_id
      t.string :espn_pro_team_id, null: false
      t.string :pro_team_id
      t.string :espn_position_id
      t.string :position_id
      t.string :jersey_number
      t.string :status
      t.timestamps
    end
  end
end
