require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = Manager.new(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.new(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")     
    @manager.save
    @user.save
      
    @team = Team.new(name: "Team 1")
    @team.save
      
    @team_no_access = Team.new(name: "Team 5")
    @team_no_access.save
      
    @team.users << @user
    @team.managers << @manager
  end

  # manager_dashboard tests
  test "should redirect to manager dashboard when user is a manager" do
    login_as_manager
    get manager_dashboard_url
    assert_response :success
  end
    
  test "should redirect to login page when user is not a manager and trying to access the manager dashboard" do
    login_as_user
    get manager_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  # team_health tests
  test "should redirect to login page when user is not a manager and trying to access team health" do
    login_as_user
    get team_health_url (@team)
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  test "should redirect to team health page for a manager who is on the team" do
    login_as_manager
    get team_health_url (@team)
    assert_response :success
  end
    
  test "should redirect to manager dashboard for a manager who tries to access the team health page of a team they are not on" do
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
    
  def login_as_manager
    post login_path, params: { watiam: @manager.watiam, password: @manager.password }
  end
 
  def login_as_user
    post login_path, params: { watiam: @user.watiam, password: @user.password }
  end
 
end
