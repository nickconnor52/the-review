class AddPositionTable < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.string :name
      t.string :abbreviation
      t.string :espn_id
      t.timestamps
    end
  end
end
