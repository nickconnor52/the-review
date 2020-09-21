class AddTradeBlockToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :on_trade_block, :boolean, default: false
    add_column :teams, :trade_block_updated_at, :datetime
  end
end
