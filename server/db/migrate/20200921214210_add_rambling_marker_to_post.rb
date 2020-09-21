class AddRamblingMarkerToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :post_type, :string, default: 'chatter'
  end
end
