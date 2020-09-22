class AddPositionNeededTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :trade_block_position_id, :string, default: '0'
  end
end
