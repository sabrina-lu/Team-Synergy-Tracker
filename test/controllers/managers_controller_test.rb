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

  test "managers should only see tickets of members on their teams" do
    setup_manager_tickets
    tickets = get_tickets_for_manager(@manager_1)
    assert_equal 2, tickets.count
    assert_equal true, tickets.include?(@t_1)
    assert_equal true, tickets.include?(@t_2)
    assert_equal false, tickets.include?(@t_3)  
      
    tickets = get_tickets_for_manager(@manager_2)
    assert_equal 0, tickets.count
    assert_equal false, tickets.include?(@t_1)
    assert_equal false, tickets.include?(@t_2)
    assert_equal false, tickets.include?(@t_3)  
        
  end
    
    # don't need to test edit manager
#  test "should get edit" do
#    get edit_manager_url(@manager)
#    assert_response :success
#  end

    # don't need to test update manager
#  test "should update manager" do
#    patch manager_url(@manager), params: { manager: { first_name: @manager.first_name, last_name: @manager.last_name, watiam: @manager.watiam } }
#    assert_redirected_to manager_url(@manager)
#  end

    # don't need to test destroying manager
#  test "should destroy manager" do
#    assert_difference('Manager.count', -1) do
#      delete manager_url(@manager)
#    end

#   assert_redirected_to managers_url
#  end
    
  def get_tickets_for_manager(manager)
      myTeams = Manager.joins(:teams).select("team_id").where(:id => manager.id) # get teams associated with this manager
      myTeamMembers = Team.joins(:users).select("id").where(:id => myTeams) # get users associated with this manager's teams
      teamMemberIds = []
      myTeamMembers.each do |ticket|
          teamMemberIds = ticket.user_ids
      end
      tickets = Ticket.where(:creator_id => teamMemberIds)  #get tickets created by users associated with this manager's teams
      return tickets
  end  
end
