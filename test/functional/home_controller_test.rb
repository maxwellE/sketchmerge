require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  test "should have sign in and sign up button" do
    get :index
    assert_select 'a#signup', :text => 'Sign Up'
    assert_select 'a#signin', :text => 'Sign In'
  end

end
