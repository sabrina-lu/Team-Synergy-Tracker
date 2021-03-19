require "application_system_test_case"
require 'test_helper'

class ManagersTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end

    # can successfully login
  test "login to dashboard" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    assert_text "Welcome " + @manager.first_name.capitalize + "!"
  end

    # login with wrong watiam
  test "login with watiam that doesn't exist" do
    visit login_path
    fill_in "watiam", with: "blah"
    fill_in "password", with: @manager.password
    click_on "Login"
    assert_text "Cannot log you in. Invalid email or password."
  end
    
    # login with wrong watiam
  test "login with password that doesn't match" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: "blah"
    click_on "Login"
    assert_text "Cannot log you in. Invalid email or password."
  end
    
    # cannot access a user's dashboard as a manager
  test "cannot access user dashboard" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit user_dashboard_url
    assert_text "Welcome " + @manager.first_name.capitalize + "!"  
  end
    
    # can sucessfully access a team's team health
  test "can access team health" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on @team.name
    assert_text @team.name + " Health Metrics"
  end

    # can successfully view tickets
  test "can view team's tickets" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View All Tickets"
    assert_text "My Team's Tickets"
  end
    
  test "manager dashboard can view weekly survey completion ratio" do 
    setup_tickets   
    @m = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users] 
    @team.managers << [@manager]
    current_survey_due_date = Date.new(2021,3,20) 
      
    for i in 0..3 do 
      Survey.create(user_id: users[i].id, team_id: @team.id, date: current_survey_due_date)
    end
    
    survey = Survey.find_by(user_id: @user_3.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1) 
      
    visit login_path
    fill_in "watiam", with: @m.watiam
    fill_in "password", with: @m.password
    click_on "Login"
    assert_text "1/4"
  end
end
