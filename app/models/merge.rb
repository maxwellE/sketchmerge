class Merge < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  attr_accessible :pending, :user_id, :receiver_id
end
