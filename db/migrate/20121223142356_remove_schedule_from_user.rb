class RemoveScheduleFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :schedule
  end

  def down
    add_column :users, :schedule, :text
  end
end
