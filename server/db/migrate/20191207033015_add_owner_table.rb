class AddOwnerTable < ActiveRecord::Migration[5.1]
  def change
    create_table :owners do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :city, null: false
      t.string :season_joined, null: false
      t.string :last_active_season
      t.timestamps
    end
  end
end
