class RemoveDayIndexFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :day_index
  end

  def down
    add_column :events, :day_index, :integer
  end
end
