class AddRostersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :rosters do |t|
      t.string :team_id
      t.string :year
      t.timestamps
    end
  end
end
