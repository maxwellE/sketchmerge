FactoryGirl.define do
  factory :user do
    id 1
    username "elliomax"
    password "sweetpea"
    email "elliott.432@osu.edu"
  end
  factory :user2, class: :User do
    id 2
    username "Maxemus52"
    password "sweetpea2"
    email "maxelliott41@gmail.com"
  end
end