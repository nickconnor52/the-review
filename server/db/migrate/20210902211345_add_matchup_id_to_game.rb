class AddMatchupIdToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :sleeper_matchup_id, :string
  end
end
