class EventsController < ApplicationController
  def resize_event
    if user_signed_in?
      event = current_user.events.find(params["event_id"].to_i)
      event.start_time = DateTime.parse(params["new_start_time"])
      event.end_time = DateTime.parse(params["new_end_time"])
      Rails.logger.debug event
      event.save!
      render :json => event, :status => :ok
    else
      render :json => {:response => "Invalid request, you are not currently logged in."}, :status => :unauthorized
    end
  end
end
