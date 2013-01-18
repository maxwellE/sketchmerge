require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @sample_intersect = {"Wednesday"=>["Wednesday 08:00:00 AM", "Wednesday 08:15:00 AM", 
      "Wednesday 08:30:00 AM", "Wednesday 08:45:00 AM", "Wednesday 09:00:00 AM", "Wednesday 09:15:00 AM", 
      "Wednesday 09:30:00 AM", "Wednesday 09:45:00 AM", "Wednesday 12:00:00 PM", "Wednesday 12:15:00 PM", 
      "Wednesday 12:30:00 PM", "Wednesday 12:45:00 PM"]}
  end
  test "should be able to construct time ranges correctly" do
    day_times = Event.construct_ranges(@sample_intersect)
    assert_equal("08:00:00 AM", day_times["Wednesday"].first.first)
    assert_equal("09:45:00 AM", day_times["Wednesday"].first.last)
    assert_equal("12:00:00 PM", day_times["Wednesday"].last.first)
    assert_equal("12:45:00 PM", day_times["Wednesday"].last.last)
  end
end
