class Merge < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  attr_accessible :pending, :user_id, :receiver_id

  def self.generate_create_json(current_user,params)
    if params[:to_username] != current_user.username
      if User.exists?(:username => params[:to_username])
        if current_user.merges.exists?(:receiver_id => User.where("username = ?", params[:to_username])) or
            User.where("username = ?", params[:to_username]).first.merges.exists?(:receiver_id => current_user.id)
          {:error => "You already have merged with '#{params[:to_username]}'!"}
        else
          new_merge = current_user.merges.create(:receiver_id => User.where("username = ?", params[:to_username]).first.id)
          merge_json = {}
          merge_json["to_username"] = new_merge.receiver.username
          merge_json["merge_id"] = new_merge.id
          merge_json
        end
      else
        {:error => "User with username '#{params[:to_username]}' does not exist!"}
      end
    else
      {:error => "You cannot add yourself as a merger!"}
    end
  end

  def self.find_possible_times(current_user,users)
  end
end
