require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_users_manager_teams      
  end

  # manager_dashboard tests
  test "should redirect manager to manager dashboard" do
    login_as_manager
    get manager_dashboard_url
    assert_response :success
  end
    
  test "should redirect user to login page when trying to access the manager dashboard" do
    login_as_user
    get manager_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  # team_health tests
  test "should redirect user to login page when trying to access team health" do
    login_as_user
    get team_health_url (@team)
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  test "should redirect manager to team health page when they are on the team" do
    login_as_manager
    get team_health_url (@team)
    assert_response :success
  end
    
  test "should redirect manager to manager dashboard when accessing team health page if they are not on that team" do
    login_as_manager
    get team_health_url (@team_no_access)
    assert_redirected_to manager_dashboard_url
    assert_equal "You do not have permission to view this team." , flash[:notice] 
  end
  
  test "should get index" do
    login_as_manager
    get managers_url
    assert_response :success
  end

  test "should get new" do
    get new_manager_url
    assert_response :success
  end

  test "should create manager" do
    assert_difference('Manager.count') do
      post managers_url, params: { manager: { flag: "Manager", watiam: "bpark", password: "Password", first_name: "Bob", last_name: "Park"} }
    end
  end

  test "should show manager" do
    login_as_manager
    get manager_url(@manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_manager_url(@manager)
    assert_response :success
  end

  test "should update manager" do
    patch manager_url(@manager), params: { manager: { first_name: @manager.first_name, last_name: @manager.last_name, watiam: @manager.watiam } }
    assert_redirected_to manager_url(@manager)
  end

  test "should destroy manager" do
    assert_difference('Manager.count', -1) do
      delete manager_url(@manager)
    end

    assert_redirected_to managers_url
  end
end
