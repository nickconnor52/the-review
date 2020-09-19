class AddUsernameAndPassword < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :username, :string
  end
end
