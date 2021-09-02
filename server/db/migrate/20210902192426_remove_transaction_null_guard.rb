class RemoveTransactionNullGuard < ActiveRecord::Migration[5.1]
  def change
    change_column_null :transactions, :espn_id, true
  end
end
