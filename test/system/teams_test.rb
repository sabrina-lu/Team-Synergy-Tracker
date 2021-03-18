require "application_system_test_case"
require "test_helper"

class TeamsTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end

  test "visiting user team list" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit user_team_list_path(@team)
    assert_text "Team 1 Members"
  end
  
  test "return to dashboard from team list" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit user_team_list_path(@team)
    click_on 'Return to Dashboard'
    assert_selector "h1", text: "Welcome Joe!"
  end
    
  test "visiting manager team list" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit team_health_path(@team)
    assert_text "Team 1 Health Metrics"
  end
  
  test "manager team list includes completed weekly survey indicator" do 
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
    visit team_health_path(@team)
    assert_text "Completed Weekly Survey"
    assert_text "No", count: 3
    assert_text "Yes", count: 1
    
  end

  test "creating a team" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on 'New Team'
    assert_text 'New Team'
    fill_in "Name", with: @team.name
    click_on "Continue to Adding Members"

    assert_text "Team was successfully created"
    click_on "Back"
  end
    
end
