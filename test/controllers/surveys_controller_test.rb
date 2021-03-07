require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do  
    setup_users_manager_teams
    @team_no_access.users << @user
    @team_no_access.managers << @manager
    Survey.create(team_id: @team.id, user_id: @user.id, date: Date.new(2021,3,4))
    Survey.create(team_id: @team_no_access.id, user_id: @user.id, date: Date.new(2021,3,4))
  end

  # create surveys tests
  test "should add next week's surveys for each student on all manager's teams" do      
    assert_difference('Survey.count', 2) do
      post surveys_url, params: { manager_id: @manager.id }
    end
  end
  
  test "should only add next week's surveys for manager's teams that have not already been updated" do
    post surveys_url, params: { manager_id: @manager.id }
    @team_3 = Team.create(name: "Team 3")
    @team_3.users << @user
    @team_3.managers << @manager
    Survey.create(team_id: @team_3.id, user_id: @user.id, date: Date.new(2021,3,4))
      
    assert_difference('Survey.count', 1) do
      post surveys_url, params: { manager_id: @manager.id }
    end
  end  
    
  test "should not add any next week's surveys for manager's teams that have no members on them" do
    setup_surveys_responses
    @team_no_access.managers << @manager
    post surveys_url, params: { manager_id: @manager.id }
    @team_3 = Team.create(name: "Team 3")
    @team_3.managers << @manager
      
    assert_difference('Survey.count', 0) do
      post surveys_url, params: { manager_id: @manager.id }
    end
  end  
end
