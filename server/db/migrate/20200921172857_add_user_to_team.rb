class AddUserToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :user_id, :string
  end
end
