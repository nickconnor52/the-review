class RemovePlayerNullConstraints < ActiveRecord::Migration[5.1]
  def change
    change_column_null :players, :espn_pro_team_id, true
    change_column_null :players, :espn_id, true
  end
end
