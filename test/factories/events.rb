# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    user_id 1
    start_time "2012-12-23 09:39:05"
    end_time "2012-12-23 11:39:05"
    day_index 1
  end
end
