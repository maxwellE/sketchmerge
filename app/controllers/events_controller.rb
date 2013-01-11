class EventsController < ApplicationController
  before_filter :authenticate_user!
  def update
    event = current_user.events.find(params["event_id"].to_i)
    event.start_time = DateTime.parse(params["new_start_time"].gsub(/\sGMT.+\z/,''))
    event.end_time = DateTime.parse(params["new_end_time"].gsub(/\sGMT.+\z/,''))
    event.save!
    render :json => event, :status => :ok
  end
  def create
    datetime = DateTime.parse("#{params["eventDate"]} #{params["eventTime"]}")
    event = current_user.events.create(:start_time => datetime, 
                                       :end_time => (datetime + 15.minutes))
    data = {:begins => event.start_time.strftime("%F %T"), 
      :ends =>event.end_time.strftime("%F %T") , 
      :uid => event.id, :color => "blue"}.to_json
    render :json => data, :status => :ok
  end
  def destroy
    current_user.events.find(params["event_id"].to_i).delete
    render :json => {}, :status => :ok
  end
end
