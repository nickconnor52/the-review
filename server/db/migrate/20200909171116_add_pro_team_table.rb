class AddProTeamTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pro_teams do |t|
      t.string :espn_id, null: false
      t.string :name, null: false
      t.string :nickname, null: false
      t.string :abbreviation
      t.string :logo_url
      t.string :conference_name
      t.timestamps
    end
  end
end
