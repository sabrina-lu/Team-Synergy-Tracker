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
  
  test "should get index" do
    get surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_survey_url
    assert_response :success
  end

    # don't need to test survey created
#  test "should create survey" do
#    assert_difference('Survey.count') do
#      post surveys_url, params: { survey: { date: @survey.date, team_id: @survey.team_id, user_id: @survey.user_id } }
#    end

#    assert_redirected_to survey_url(Survey.last)
#  end

    # don't need to test show survey
#  test "should show survey" do
#    get survey_url(@survey)
#    assert_response :success
#  end

    # don't need to test edit surveys
#  test "should get edit" do
#    get edit_survey_url(@survey)
#    assert_response :success
#  end

    # don't need to test update surveys
#  test "should update survey" do
#    patch survey_url(@survey), params: { survey: { date: @survey.date, team_id: @survey.team_id, user_id: @survey.user_id } }
#    assert_redirected_to survey_url(@survey)
#  end

    # don't need to test destroy surveys
#  test "should destroy survey" do
#    assert_difference('Survey.count', -1) do
#      delete survey_url(@survey)
#    end

#    assert_redirected_to surveys_url
#  end
end
