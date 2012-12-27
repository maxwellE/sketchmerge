class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => :dashboard
  def index
  end
  def dashboard
    @events = current_user.events
    gon.start_date = Time.now.beginning_of_week(:sunday).strftime("%Y-%m-%d")
    gon.jbuilder
  end
end
