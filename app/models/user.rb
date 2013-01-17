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

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:username
  # attr_accessible :title, :body
  def consolidate_events
    result = []
    events.each do |event|
      result = result | event.to_blocks_of_minutes(15)
    end
    result
  end
end
