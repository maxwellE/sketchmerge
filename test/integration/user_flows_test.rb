require 'test_helper'
require 'launchy'
class UserFlowsTest < ActionDispatch::IntegrationTest
  setup do
    require 'capybara/poltergeist'
    Capybara.javascript_driver = :poltergeist
    @user = FactoryGirl.create(:user)
    @event |= @user.events.create(:day_index => 0, 
    :start_time => Chronic.parse('today 6 AM').to_time, 
    :end_time => Chronic.parse('today 6:30 AM').to_time)
    if Date.today.sunday?
      @start_date |= Date.today
    else
      @start_date |= Chronic.parse('last sunday')
    end
    visit(root_path)
    click_on('Sign In')
    fill_in('Email', :with => @user.email)
    fill_in('Password', :with => @user.password)
    click_on('Sign in')
  end

  test 'should arrive at user dashboard' do
    assert !page.has_content?('Sign in'),"not on signin page"
    assert(page.has_content?("Your `Sketch"),"should have sketch")
    assert(page.has_content?("Your Merges"),"should have merges")
    assert(page.has_content?("Logout"),"no logout button")    
    assert(page.has_content?("Edit Profile"), 'no edit profile button')    
  end
  
  test "should have a rendered event on the calendar" do
     assert(page.has_content?("Available"),"should have event text")
  end
end
