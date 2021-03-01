require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = Manager.new(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.new(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")     
    @user_2 = User.new(watiam: "naccess", first_name: "no", last_name: "access", password: "Password")
    @manager.save
    @user.save
    @user_2.save
      
    @team = Team.new(name: "Team 1")
    @team.save
      
    @team_no_access = Team.new(name: "Team 5")
    @team_no_access.save
      
    @team.users << @user
    @team.managers << @manager
      
    @survey = Survey.new(id: 1, user_id: 1, team_id: 1)
    @survey_no_access = Survey.new(id: 2, user_id: 2, team_id: 1)
    @survey_no_access_2 = Survey.new(id: 3, user_id: 2, team_id: 2)
    @survey.save
    @survey_no_access.save
    @survey_no_access_2.save
    
    @response = Response.new(id: 1, survey_id: 1, question_number: 1, answer: 5)
    @response_no_access = Response.new(id: 2, survey_id: 2, question_number: 1, answer: 3)
    @response_no_access_2 = Response.new(id: 3, survey_id: 3, question_number: 1, answer: 1)
      
    @response.save
    @response_no_access.save
    @response_no_access_2.save
  end
    
  # show tests
  test "should redirect manager to manager dashboard when trying to view a response" do
    login_as_manager
    get response_url(@response)
    assert_redirected_to manager_dashboard_url
    assert_equal "You can not view a student\'s response." , flash[:notice] 
  end

    
  def login_as_manager
    post login_path, params: { watiam: @manager.watiam, password: @manager.password }
  end
 
  def login_as_user
    post login_path, params: { watiam: @user.watiam, password: @user.password }
  end
  
end
