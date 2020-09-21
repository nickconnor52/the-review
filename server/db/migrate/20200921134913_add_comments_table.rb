class AddCommentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.string :user_id
      t.string :parent_comment_id
      t.string :post_id
      t.timestamps
    end
  end
end
