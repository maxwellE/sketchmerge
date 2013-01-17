require 'test_helper'
require 'launchy'
require 'capybara/poltergeist'
require 'pry'

class UserFlowsTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.javascript_driver = :poltergeist
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user2)
    @merge = FactoryGirl.create(:merge)
    visit(root_path)
    click_on('Sign In')
    fill_in('Email', :with => @user.email)
    fill_in('Password', :with => @user.password)
    click_on('Sign in')
  end

  test 'should arrive at user dashboard' do
    assert page.has_no_content?('Sign in'),"not on signin page"
    assert(page.has_content?("Your `Sketch"),"should have sketch")
    assert(page.has_content?("Your Merges"),"should have merges")
    assert(page.has_content?("Logout"),"no logout button")    
    assert(page.has_content?("Edit Profile"), 'no edit profile button')    
  end
  test "should see pending merges" do
    assert(page.has_content?('Maxemus52'), "should see merge username")
  end
end
