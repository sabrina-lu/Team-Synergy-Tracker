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
    assert_redirected_to user_dashboard_url
    assert_equal "Please login as a manager to view this page.", flash[:notice] 
  end
  
  # team_health tests
  test "should redirect user to login page when trying to access team health" do
    login_as_user
    get team_health_url (@team)
    assert_redirected_to user_dashboard_url
    assert_equal "Please login as a manager to view this page.", flash[:notice] 
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

  test "should get new" do
    get new_manager_url
    assert_response :success
  end

  test "should create manager" do
    assert_difference('Manager.count') do
      post managers_url, params: { manager: { flag: "Manager", watiam: "bpark", password: "Password", first_name: "Bob", last_name: "Park"} }
    end
  end
    
  # tickets tests
  test "should show manager team's ticket" do
    @user2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @team.users << @user2
    @t_1 = Ticket.create(creator_id: @user.id, date:"13/03/2021", team_id: @team.id)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 1, answer: 1)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 2, answer: 2)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 3, answer: 3)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 4, answer: 2)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 5, answer: 7)
    @t_1.users << [@user2]
    login_as_manager
    get team_tickets_url (@team)
    assert_response :success
  end
    
  test "manager tickets page should still be successful even if they have no tickets associated to them" do
    login_as_manager
    get team_tickets_url (@team)
    assert_response :success
  end
  
  test "should redirect user to user dashboard page when accessing manager ticket page" do
    login_as_user
    get team_tickets_url (@team)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view tickets.", flash[:notice]
  end
    
  test "should log out manager" do
    login_as_manager
    get logout_url
    get manager_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please log in.", flash["notice"]
  end 
  
  # surveys tests
  test "should show manager team's surveys" do
    @user2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @team.users << @user2
    @s_1 = Survey.create(user_id: @user.id, date:"13/03/2021", team_id: @team.id)
    Response.create(survey_id: @s_1.id, question_number: 1, answer: 1)
    Response.create(survey_id: @s_1.id, question_number: 2, answer: 2)
    Response.create(survey_id: @s_1.id, question_number: 3, answer: 3)
    Response.create(survey_id: @s_1.id, question_number: 4, answer: 2)
    login_as_manager
    get team_surveys_url(id: @team.id, date: @s_1.date)
    assert_response :success
  end
    
  test "manager surveys page should still be successful even if no surveys have been completed" do
    login_as_manager
    get team_surveys_url(id: @team.id, date: "06/04/2021")
    assert_response :success
  end
  
  test "should redirect user to user dashboard page when accessing survey page" do
    login_as_user
    get team_surveys_url(id: @team.id, date: "06/04/2021")
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view surveys.", flash[:notice]
  end
end
