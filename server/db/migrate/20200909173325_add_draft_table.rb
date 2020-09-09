class AddDraftTable < ActiveRecord::Migration[5.1]
  def change
    create_table :drafts do |t|
      t.string :year
      t.timestamps
    end
  end
end
