class RemovePendingFromMerge < ActiveRecord::Migration
  def up
    remove_column :merges, :pending
  end

  def down
    add_column :merges, :pending, :boolean
  end
end
