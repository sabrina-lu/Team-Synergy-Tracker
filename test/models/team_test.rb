require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  
  #team validations tests
  test "Should successfully create a team with a valid name" do
    assert @team = Team.create(name: "Team 3").valid?
  end
  
  test "Should fail to create a team with a blank name" do
    assert_not @team = Team.create(name: "").valid?
  end
  
  test "Should fail to create a team with a null name" do
    assert_not @team = Team.create(name: nil).valid?
  end
  
  test "Should fail to create a team with a too long name" do
    assert_not @team = Team.create(name: "This is a team name that is way too long and should be so much shorter").valid?
  end
  
  test "Should fail to create a team with just whitespace for its name" do
    assert_not @team = Team.create(name: "          ").valid?
  end
    
  #get_survey_completion_ratio 
  test "should return ratio of users who have completed surveys for specific team" do
    setup_tickets      
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users]    
    current_survey_due_date = Date.new(2021,3,20) 
      
    for i in 0..3 do 
      Survey.create(user_id: users[i].id, team_id: @team.id, date: current_survey_due_date)
    end
    
    # no users have responded to the survey yet    
    assert_equal "0/4", @team.get_survey_completion_ratio(current_survey_due_date)
      
    survey = Survey.find_by(user_id: @user_4.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # only user 4 has responded to the survey   
    assert_equal "1/4", @team.get_survey_completion_ratio(current_survey_due_date) 
      
    survey = Survey.find_by(user_id: @user_2.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    survey = Survey.find_by(user_id: @user_3.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # user 2, user 3 and user 4 have responded to the survey     
    assert_equal "3/4", @team.get_survey_completion_ratio(current_survey_due_date) 
  end
    
  #weekly_survey_team_health
  test "should return current week's team health" do
    
  end
end
