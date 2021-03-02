require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_surveys_responses
  end
    
  # show response tests
  test "should redirect manager to manager dashboard when trying to view a response" do
    login_as_manager
    get response_url(Response.first)
    assert_redirected_to manager_dashboard_url
    assert_equal "You can not view a student\'s response." , flash[:notice] 
  end
    
  test "should redirect user to response if they created the response" do
    login_as_user
    get response_url(Response.first)
    assert_response :success
  end
    
  test "should redirect user to user dashboard if they are trying to view another student's response" do
    login_as_user
    get response_url(Response.last)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view this response." , flash[:notice] 
  end
  
  #edit response tests
  test "should redirect manager to manager dashboard when trying to edit a response" do
    login_as_manager
    get edit_response_url(Response.first)
    assert_redirected_to manager_dashboard_url
    assert_equal "You can not edit a student\'s response." , flash[:notice] 
  end
    
  test "should redirect user to edit response if they created the response" do
    login_as_user
    get edit_response_url(Response.first)
    assert_response :success
  end
  
  test "should redirect user user dashboard if they are trying to edit another student's response" do
    login_as_user
    get edit_response_url(Response.last)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to edit this response." , flash[:notice] 
  end

  test "should get index" do
    get responses_url
    assert_response :success
  end

  test "should get new" do
    get new_response_url
    assert_response :success
  end

  test "should create response" do
    assert_difference('Response.count') do
      post responses_url, params: { response: { question_number: @response.question_number, answer: @response.answer, survey_id: @response.survey_id } }
    end

    assert_redirected_to response_url(Response.last)
  end

  test "should update response" do
    patch response_url(@response), params: { response: { question_number: @response.question_number, answer: @response.answer, survey_id: @response.survey_id } }
    assert_redirected_to response_url(@response)
  end

  test "should destroy response" do
    assert_difference('Response.count', -1) do
      delete response_url(@response)
    end

    assert_redirected_to responses_url
  end
end
