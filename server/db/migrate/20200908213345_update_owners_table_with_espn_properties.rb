class UpdateOwnersTableWithEspnProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :owners, :team_id, :string
    add_column :owners, :espn_id, :string
  end
end
