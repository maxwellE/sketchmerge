class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :events, :dependent => :destroy
  has_many :merges
  has_many :received_merges, :class_name => "Merge", :foreign_key => "receiver_id"

  validates_presence_of :username
  validates_uniqueness_of :username
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:username,:login
  # attr_accessible :title, :body
  def consolidate_events
    result = []
    events.each do |event|
      result = result | event.to_blocks_of_minutes(15)
    end
    result
  end
  def merge_with_other_users(user_list)
    all_times = consolidate_events
    return {:error => "You have no available times! No one can meet with you! Edit the calendar to mark you availability and try again."} if all_times.empty?
    user_list.each do |user|
      all_times = all_times & user.consolidate_events
      if all_times.empty?
        return {:error => "No possible meeting times exist with '#{user_list.map{|x| x.username}.join(',')}'. Try removing a user to continue."}
      end
    end
    Event.construct_ranges(all_times.group_by{|x| x.split.first})
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
