require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do    
  end

  # create surveys tests
  test "should add next week's surveys for each student on all manager's teams" do
    setup_surveys_responses
    @team_no_access.managers << @manager
      
    assert_difference('Survey.count', 2) do
      post surveys_url, params: { manager_id: @manager.id }
    end
  end
  
  test "should only add next week's surveys for manager's teams that have not already been updated" do
    setup_surveys_responses
    @team_no_access.managers << @manager
    post surveys_url, params: { manager_id: @manager.id }
    @team_3 = Team.create(name: "Team 3")
    @team_3.managers << @manager
    add_member_to_team_and_survey(@team_3, @user.id)
      
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
