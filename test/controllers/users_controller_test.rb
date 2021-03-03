require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_users_manager_teams
  end

  # dashboard tests
  test "should redirect user to user dashboard" do
    login_as_user
    get user_dashboard_url
    assert_response :success
  end
  
  test "should redirect manager to manager dashboard when accessing user dashboard" do
    login_as_manager
    get user_dashboard_url
    assert_redirected_to manager_dashboard_url
  end
    
  # team_list tests
  test "should redirect user to team list page if they are on the team" do
    login_as_user
    get user_team_list_url(@team)
    assert_response :success
  end
  
  test "should redirect user to user dashboard when accessing team list if they are not on the team" do
    login_as_user
    get user_team_list_url(@team_no_access)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view this team." , flash[:notice] 
  end
    
  test "should redirect manager to manager team health page when accessing user team list page" do
    login_as_manager
    get user_team_list_url(@team)
    assert_redirected_to team_health_url(@team)
  end
    
  # weekly_surveys
  test "should redirect manager to manager dashboard when accessing weekly surveys" do
    login_as_manager
    get weekly_surveys_url(@team)
    assert_redirected_to manager_dashboard_url
    assert_equal "You do not have permission to respond to surveys." , flash[:notice] 
  end
  
  test "should redirect user to weekly survey page if they are on the team" do 
    setup_surveys_responses
    login_as_user(@user)
    get weekly_surveys_url(@team)
    assert_response :success
  end
    
  test "should redirect user to user dashboard when accessing weekly survey if they are not on the team" do
    setup_surveys_responses
    login_as_user(@user)
    get weekly_surveys_url(@team_no_access)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to respond to another team\'s survey.", flash["notice"]
  end 
    
  # tickets tests
  test "user tickets page should still be successful even if they have no tickets associated to them" do
    login_as_user
    get user_tickets_url
    assert_response :success
  end
      
  test "users should only see tickets they created or about themselves" do
    setup_tickets
    tickets = get_tickets_for_user(@user_2)
    assert_equal 3, tickets.count
    assert_equal true, tickets.include?(@t_1)
    assert_equal true, tickets.include?(@t_2)
    assert_equal true, tickets.include?(@t_3)  
      
    tickets = get_tickets_for_user(@user_1)
    assert_equal 2, tickets.count
    assert_equal true, tickets.include?(@t_1)
    assert_equal true, tickets.include?(@t_2)
    assert_equal false, tickets.include?(@t_3)    
      
    tickets = get_tickets_for_user(@user_3)
    assert_equal 2, tickets.count
    assert_equal true, tickets.include?(@t_1)
    assert_equal false, tickets.include?(@t_2)
    assert_equal true, tickets.include?(@t_3)    
  end
    
  # TODO: add a test - should redirect manager to manager tickets page when trying to access user tickets page
  
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
    
  def get_tickets_for_user(user)
    tickets = Ticket.where(user_id: user.id)
    tickets = tickets + User.find(user.id).tickets
    return tickets
  end
  
end
