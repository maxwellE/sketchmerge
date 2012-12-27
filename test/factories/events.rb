# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    user_id 1
    start_time Chronic.parse('Sunday December 9th 6 AM')
    end_time Chronic.parse('Sunday December 9th 6:30 AM')
  end
end
