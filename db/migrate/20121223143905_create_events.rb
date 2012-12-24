class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.time :start_time
      t.time :end_time
      t.integer :day_index

      t.timestamps
    end
  end
end
