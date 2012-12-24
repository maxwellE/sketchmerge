class Event < ActiveRecord::Base
  attr_accessible :day_index, :end_time, :start_time, :user_id
  belongs_to :user
end
