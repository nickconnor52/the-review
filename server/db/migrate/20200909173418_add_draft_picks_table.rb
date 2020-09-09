class AddDraftPicksTable < ActiveRecord::Migration[5.1]
  def change
    create_table :draft_picks do |t|
      t.string :player_id
      t.string :team_id
      t.string :draft_id
      t.string :round_number
      t.string :round_pick_number
      t.string :overall_pick_number
      t.string :original_pick_team_id
      t.timestamps
    end
  end
end
