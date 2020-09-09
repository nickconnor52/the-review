class AddTransactionPiecesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_pieces do |t|
      t.string :from_team_id
      t.string :to_team_id
      t.string :player_id
      t.string :draft_pick_id
      t.string :action_type
      t.string :transaction_id
      t.timestamps
    end
  end
end
