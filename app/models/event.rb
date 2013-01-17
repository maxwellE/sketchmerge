class Event < ActiveRecord::Base
  attr_accessible :day_index, :end_time, :start_time, :user_id
  belongs_to :user
  def to_blocks_of_minutes(mins)
    temp_time = start_time
    times = []
    until temp_time == end_time
      times.push temp_time.strftime("%A %r")
      temp_time += mins.minutes
    end
    times
  end
  def self.construct_ranges(time_hash)
    
  end
end
