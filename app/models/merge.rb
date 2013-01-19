class Merge < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  attr_accessible :pending, :user_id, :receiver_id

  def self.generate_create_json(current_user,to_user)
    if to_user != current_user.username
      if User.exists?(:username => to_user)
        if current_user.merges.exists?(:receiver_id => User.where("username = ?", to_user)) or
            User.where("username = ?", to_user).first.merges.exists?(:receiver_id => current_user.id)
          {:error => "You already have merged with '#{to_user}'!"}
        else
          new_merge = current_user.merges.create(:receiver_id => User.where("username = ?", to_user).first.id)
          merge_json = {}
          merge_json["to_username"] = new_merge.receiver.username
          merge_json["merge_id"] = new_merge.id
          merge_json
        end
      else
        {:error => "User with username '#{to_user}' does not exist!"}
      end
    else
      {:error => "You cannot add yourself as a merger!"}
    end
  end
end
