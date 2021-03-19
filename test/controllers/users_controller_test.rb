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
    @user_1 = User.create(watiam: "user1", password: "Password", first_name: "user", last_name: "one")
    @team_1 = Team.create(name: "Team 1")
    add_member_to_team_and_survey(@team_1, @user_1.id)
    login_as_user(@user_1)
    get weekly_surveys_url(@team_1)
    assert_response :success
  end
    
  test "should redirect user to user dashboard when accessing weekly survey if they are not on the team" do
    setup_surveys_responses
    login_as_user(@user)
    get weekly_surveys_url(@team_no_access)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to respond to another team\'s survey.", flash["notice"]
  end 
    
  test "should redirect user to user dashboard when accessing weekly survey that user has already completed" do
    setup_surveys_responses
    login_as_user(@user)
    get weekly_surveys_url(@team)
    assert_redirected_to user_dashboard_url
    assert_equal "You have already submitted this week's survey.", flash["notice"]
  end 
    
  test "should create a survey for this week automatically" do
    @user_1 = User.create(watiam: "user1", password: "Password", first_name: "user", last_name: "one")
    @team_1 = Team.create(name: "Team 1")
    @team_1.users << @user_1
    @team_2 = Team.create(name: "Team 2")
    @team_2.users << @user_1
    Survey.create(team_id: @team_1.id, user_id: @user_1.id, date: Date.new(2021,3,6))      
    Survey.create(team_id: @team_2.id, user_id: @user_1.id, date: Date.new(2021,3,6))
    login_as_user(@user_1)
    assert_difference('Survey.count', 2) do     
      get user_dashboard_url
    end   
  end
    
  # tickets tests
  test "user tickets page should still be successful even if they have no tickets associated to them" do
    login_as_user
    get user_tickets_url
    assert_response :success
  end
  
  test "should redirect manager to manager ticket page when accessing user ticket page" do
    login_as_manager
    get user_tickets_url
    assert_redirected_to manager_tickets_url
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

  # can successfully create user account
  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: {flag: "User", watiam: "emmalinuser", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end

    assert_redirected_to root_url
  end

  test "should create manager" do
    assert_difference('Manager.count') do
      post users_url, params: { user: {flag: "Manager", watiam: "emmalinuser", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end

    assert_redirected_to root_url
  end
    
  test "should not create user if an existing manager has the same watiam" do
    Manager.create(watiam: "test", first_name: "test", last_name: "user", password: "Password", password_confirmation: "Password")
    assert_difference('User.count', 0) do
      post users_url, params: { user: {flag: "User", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end
    assert_equal "That WATIAM has an account associated with it already", flash[:alert]
  end
    
  test "should not create manager if an existing user has the same watiam" do
    User.create(watiam: "test", first_name: "test", last_name: "manager", password: "Password", password_confirmation: "Password")
    assert_difference('Manager.count', 0) do
      post users_url, params: { user: {flag: "Manager", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end
    assert_equal "That WATIAM has an account associated with it already", flash[:alert]
  end
    
  test "should not create user if an existing user has the same watiam" do
    User.create(watiam: "test", first_name: "test", last_name: "user", password: "Password", password_confirmation: "Password")
    assert_difference('User.count', 0) do
      post users_url, params: { user: {flag: "User", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end
    assert_equal "That WATIAM has an account associated with it already", flash[:alert]
  end
    
  test "should not create manager if an existing manager has the same watiam" do
    Manager.create(watiam: "test", first_name: "test", last_name: "manager", password: "Password", password_confirmation: "Password")
    assert_difference('Manager.count', 0) do
      post users_url, params: { user: {flag: "Manager", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "Password"  } }
    end
    assert_equal "That WATIAM has an account associated with it already", flash[:alert]
  end 
    
  test "should not create user or manager if password is blank" do
    assert_difference('User.count', 0) do
      post users_url, params: { user: {flag: "User", watiam: "test", password: "", first_name: "Emma", last_name: "Lin", password_confirmation: ""  } }
    end
      
    assert_difference('Manager.count', 0) do
      post users_url, params: { user: {flag: "Manager", watiam: "test", password: "", first_name: "Emma", last_name: "Lin", password_confirmation: ""  } }
    end
  end
    
  test "should not create user or manager if password and password confirmation do not match" do
    assert_difference('User.count', 0) do
      post users_url, params: { user: {flag: "User", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "password"  } }
    end
      
    assert_difference('Manager.count', 0) do
      post users_url, params: { user: {flag: "Manager", watiam: "test", password: "Password", first_name: "Emma", last_name: "Lin", password_confirmation: "password"  } }
    end  
  end  
    
  test "should log out user" do
    login_as_user
    get logout_url
    get user_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please log in.", flash["notice"]
  end
    
  def get_tickets_for_user(user)
    tickets = Ticket.where(creator_id: user.id)
    tickets = tickets + User.find(user.id).tickets
    return tickets
  end
  
end