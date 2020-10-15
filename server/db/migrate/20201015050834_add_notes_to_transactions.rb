class AddNotesToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :note, :string
  end
end
