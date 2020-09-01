class AddPostTable < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps
    end

    add_reference :posts, :user, foreign_key: true
  end
end
