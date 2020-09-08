class AddTeamTable < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :espn_id, null: false
      t.string :location, null: false
      t.string :nickname, null: false
      t.string :abbreviation, null: false
      t.string :logo_url, null: false
      t.timestamps
    end
  end
end
