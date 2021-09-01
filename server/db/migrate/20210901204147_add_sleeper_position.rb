class AddSleeperPosition < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :sleeper_position_id, :string
    add_column :players, :sleeper_pro_team_id, :string
    add_column :players, :sleeper_fantasy_team_id, :string
  end
end
