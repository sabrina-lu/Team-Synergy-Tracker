require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # User Validations Tests
  test "Should successfully create a user" do
    assert @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "Password").valid?
  end
  
  test "Should successfully create a user with minimum password length" do
    assert @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "onetwo").valid?
  end
  
  test "Should fail to create a user with too short password length" do
    assert_not @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "short").valid?
  end
  
  test "Should fail to create a user with null password" do
    assert_not @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: nil).valid?
  end
  
  test "Should fail to create a user with too long password" do
    assert_not @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "fI94Xfq*7EJzLA!h@VGSFahACC").valid?
  end
  
  test "Should successfully create a user with max length password" do
    assert @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "Yl93&OJs6YqI*1CO7u@jhPcvI").valid?
  end
  
  test "Should fail to create a user with a space in the password" do
    assert_not @user = User.create(user_id: 20567890, watiam: "u1", first_name: "user1", last_name: "one", password: "pass word").valid?
  end
  
  test "Should fail to create a user with a space in the user_id" do
    assert_not @user = User.create(user_id: "2056 890".to_i, watiam: "u1", first_name: "user1", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a user with a space in the watiam" do
    assert_not @user = User.create(user_id: 20567890, watiam: "kasj d90p", first_name: "user1", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a user with too short user_id " do
    assert_not @user = User.create(user_id: 2056789, watiam: "whyamIhere", first_name: "user1", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a user with too long user_id " do
    assert_not @user = User.create(user_id: 205678901, watiam: "whyamIhere", first_name: "user1", last_name: "one", password: "password").valid?
  end
  
    
  # get_ordered_survey_indicator tests
  test "should return users in order of users who haven't completed the survey to users who have" do
    setup_tickets      
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users]    
    current_survey_due_date = Date.new(2021,3,20) 
      
    for i in 0..3 do 
      Survey.create(user_id: users[i].id, team_id: @team.id, date: current_survey_due_date)
    end
    
    # no users have responded to the survey yet
    actual = [[@user_4, "No"], [@user_3, "No"], [@user_2, "No"], [@user_1, "No"]]       
    assert_equal actual, User.get_ordered_survey_indicator(@team, current_survey_due_date) 
      
    survey = Survey.find_by(user_id: @user_4.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # only user 4 has responded to the survey
    actual = [[@user_3, "No"], [@user_2, "No"], [@user_1, "No"], [@user_4, "Yes"]]       
    assert_equal actual, User.get_ordered_survey_indicator(@team, current_survey_due_date) 
      
    survey = Survey.find_by(user_id: @user_2.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # user 2 and user 4 have responded to the survey
    actual = [[@user_3, "No"], [@user_1, "No"], [@user_2, "Yes"], [@user_4, "Yes"]]       
    assert_equal actual, User.get_ordered_survey_indicator(@team, current_survey_due_date) 
  end

  
end

