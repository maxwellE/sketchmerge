class MergesController < ApplicationController
  before_filter :authenticate_user!
  def create
    if params[:to_username] != current_user.username
      if User.exists?(:username => params[:to_username])
        if current_user.merges.exists?(:receiver_id => User.where("username = ?",params[:to_username]))
          render :json => {:error => "You already have merged with '#{params[:to_username]}'!"}
        else
          new_merge = current_user.merges.create(:receiver_id => User.where("username = ?",params[:to_username]).first.id)
          merge_json = {}
          merge_json["to_username"] = new_merge.receiver.username
          merge_json["merge_id"] = new_merge.id
          render :json => merge_json
        end
      else
        render :json => {:error => "User with username '#{params[:to_username]}' does not exist!"}
      end
    else
      render :json => {:error => "You cannot add yourself as a merger!"}
    end
  end
end
