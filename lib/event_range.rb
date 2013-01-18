require 'chronic'
class EventRange  
  def self.time_ranges(times)
    result_ranges = []
    current_range = []
    times.map{|x| Chronic.parse(x)}.each do |time|
      if current_range.empty?
        current_range.push time
      else
        if current_range.last.nil? || (current_range.last + 15.minutes) == time
          current_range.push time
        else
          result_ranges.push [current_range.first.strftime("%r"),(current_range.last+15.minutes).strftime("%r")]
          current_range = [time]
        end
      end
    end
    unless current_range.empty?
      if current_range.first && current_range.last
        result_ranges.push [current_range.first.strftime("%r"),(current_range.last+15.minutes).strftime("%r")]
      end
    end
    result_ranges
  end
end