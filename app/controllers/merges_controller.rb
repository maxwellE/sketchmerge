class MergesController < ApplicationController
  before_filter :authenticate_user!
  def create
    render :json => Merge.generate_create_json(current_user,params)
  end
  def find_time
    render :json => Merge.find_possible_times(current_user,params[:to_users])
  end
end
