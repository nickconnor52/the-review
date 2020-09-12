class AddTeamInfoToTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :teams_transactions do |t|
      t.references :team, foreign_key: true
      t.references :transaction, foreign_key: true
      t.timestamps
    end
  end
end
