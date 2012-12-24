class EventsController < ApplicationController
  def grab_events
    logger.info("session info" + session.inspect)
    logger.info("got to events")
    respond_to do |format|
       format.json
     end
  end
end
