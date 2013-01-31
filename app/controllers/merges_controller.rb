class MergesController < ApplicationController
  before_filter :authenticate_user!
  def create
    render :json => Merge.generate_create_json(current_user,params[:to_username])
  end

  def destroy
    Rails.logger.debug { params.inspect }
    render :json => {success:true} 
  end

  def find_time
    render :json => current_user.merge_with_other_users(params[:to_users].map{|x| User.find_by_username(x)})
  end
end
