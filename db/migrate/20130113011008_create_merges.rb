class CreateMerges < ActiveRecord::Migration
  def change
    create_table :merges do |t|
      t.boolean :pending
      t.integer :user_id
      t.integer :receiver_id
      t.timestamps
    end
  end
end
