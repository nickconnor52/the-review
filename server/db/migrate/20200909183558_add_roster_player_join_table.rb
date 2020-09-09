class AddRosterPlayerJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :players_rosters do |t|
      t.references :player, foreign_key: true
      t.references :roster, foreign_key: true
      t.timestamps
    end
  end
end
