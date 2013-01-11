json.array!(@events) do |event|
  new_date = Time.now.beginning_of_week(:sunday) + event.start_time.wday.days
  result = new_date.strftime("%F")
  result << event.start_time.strftime(" %T")
  json.uid event.id
  json.begins result
  result = new_date.strftime("%F")
  result << event.end_time.strftime(" %T")
  json.ends result
  json.notes "Avaliable"
  json.color "blue"
end