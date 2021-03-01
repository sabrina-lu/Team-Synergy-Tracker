require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
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

  # dashboard tests
  test "should redirect to user dashboard when user is not a manager" do
    login_as_user
    get user_dashboard_url
    assert_response :success
  end
  
  test "should redirect to manager dashboard when user is a manager" do
    login_as_manager
    get user_dashboard_url
    assert_redirected_to manager_dashboard_url
  end
    
  # team_list tests
  test "should redirect to team list page when user is not a manager and on the team" do
    login_as_user
    get user_team_list_url(@team)
    assert_response :success
  end
  
  test "should redirect to user dashboard when user is not a manager and not on the team" do
    login_as_user
    get user_team_list_url(@team_no_access)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view this team." , flash[:notice] 
  end
    
  test "should redirect to manager team health page when user is a manager" do
    login_as_manager
    get user_team_list_url(@team)
    assert_redirected_to team_health_url(@team)
  end
    
  # weekly_surveys
  test "should redirect to manager dashboard when user is a manager and try accessing the weekly surveys" do
    login_as_manager
    get weekly_surveys_url(@team)
    assert_redirected_to manager_dashboard_url
    assert_equal "You do not have permission to respond to surveys." , flash[:notice] 
  end
    
  # TODO: add a test that checks to make sure that a user can not access weekly surveys for teams they are not on
    
  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: {  } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: {  } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
    
  def login_as_manager
    post login_path, params: { watiam: @manager.watiam, password: @manager.password }
  end
 
  def login_as_user
    post login_path, params: { watiam: @user.watiam, password: @user.password }
  end
end
