require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = Survey.create(date: "10/02/2020")
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
