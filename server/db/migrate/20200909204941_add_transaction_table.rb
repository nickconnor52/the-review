class AddTransactionTable < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :espn_id, null: false
      t.string :accepted_date
      t.string :transaction_type
      t.string :bid_amount
      t.timestamps
    end
  end
end
