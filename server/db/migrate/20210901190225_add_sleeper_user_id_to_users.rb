class AddSleeperUserIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :owners, :sleeper_id, :string
    add_column :players, :sleeper_id, :string
    add_column :positions, :sleeper_id, :string
    add_column :pro_teams, :sleeper_id, :string
    add_column :teams, :sleeper_id, :string
    add_column :transactions, :sleeper_id, :string
  end
end
