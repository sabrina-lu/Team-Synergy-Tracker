require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  setup do
    setup_users_manager_teams      
  end
    
  # current_user_is_manager tests
  test "should return nil if current user is nil" do 
    assert_nil current_user_is_manager
  end
    
  test "should return nil if current user is not a manager" do 
    log_in @user
    assert_nil current_user_is_manager
  end

  test "should return manager if current user is a manager" do
    log_in @manager
    assert_equal @manager, current_user_is_manager
  end

  #current_user_is_on_team(team) tests
  test "should return false when current_user is nil" do
    assert_equal false, current_user_is_on_team(@team)
  end
    
  test "should return false when user is not on team" do
    log_in @user
    assert_equal false, current_user_is_on_team(@team_no_access)
  end
    
  test "should return true when user is on team" do
    log_in @user
    assert_equal true, current_user_is_on_team(@team)
  end
    
  test "should return false when manager is not on team" do
    log_in @manager
    assert_equal false, current_user_is_on_team(@team_no_access)
  end
    
  test "should return true when manager is on team" do
    log_in @manager
    assert_equal true, current_user_is_on_team(@team)
  end
end