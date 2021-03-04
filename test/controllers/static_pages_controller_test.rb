require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  setup do 
    setup_users_manager_teams
  end
    
  # check that manager successfully reaches root (dashboard)
  test "should get manager home" do
    login_as_manager
    assert(get root_url)
  end
    
  # check that user successfully reaches root (dashboard)
  test "should get user home" do
    login_as_user
    assert(get root_url)
  end

end
