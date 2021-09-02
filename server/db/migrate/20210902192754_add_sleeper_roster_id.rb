class AddSleeperRosterId < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :sleeper_roster_id, :string
  end
end
