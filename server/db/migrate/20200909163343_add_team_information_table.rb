class AddTeamInformationTable < ActiveRecord::Migration[5.1]
  def change
    create_table :team_identifiers do |t|
      t.string :team_id, null: false
      t.string :location, null: false
      t.string :nickname, null: false
      t.string :abbreviation, null: false
      t.string :logo_url
      t.timestamps
    end

    remove_column :teams, :location
    remove_column :teams, :nickname
    remove_column :teams, :abbreviation
    remove_column :teams, :logo_url
  end
end
