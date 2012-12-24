require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get grab_events" do
    get :grab_events
    assert_response :success
  end

end
