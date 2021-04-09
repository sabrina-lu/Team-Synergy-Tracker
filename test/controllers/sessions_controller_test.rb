require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_users_manager_teams
  end 
    
  test "should get new" do
    get sessions_new_url
    assert_response :success
  end
    
  test "should redirect to manager dashboard if logged in as manager" do
    login_as_manager
    get sessions_new_url
    assert_redirected_to manager_dashboard_url
  end
    
  test "should redirect to user dashboard if logged in as user" do
    login_as_user
    get sessions_new_url
    assert_redirected_to user_dashboard_url
  end
    
  test "should not log user in if password is invalid" do
    post login_url, params: { watiam: "#{@user.watiam}", password: "Psdddd" }
      assert_equal 'Cannot log you in. Invalid Watiam or Password.', flash.now[:alert]
  end    

end
