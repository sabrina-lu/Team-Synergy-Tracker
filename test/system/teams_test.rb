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
    assert_text "Team 1 Details"
    assert_text "Members"
  end
    
    # Should see the current week's team health
    # Story: Modify user team page to display team health
  test "should see team health when visiting user team list" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit user_team_list_path(@team)
    assert_text "Current Week's Team Health"
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
  
    # Should show an indicator beside the team member list for each member
    # Should show Yes in green for users who have completed the survey and No in red for users who have not
    # Should show user who haven't completed the survey first
    # Story: Manager can see which users did not complete weekly survey
  test "manager team list includes completed weekly survey indicator" do 
    setup_tickets   
    @m = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users] 
    @team.managers << [@manager]
    visit login_path
    fill_in "watiam", with: @user_3.watiam
    fill_in "password", with: @user_3.password
    click_on "Login"
    click_on "Team 1"
    click_on "Weekly Surveys"
    choose "1", :id => :answer1_1
    choose "1", :id => :answer2_1
    choose "1", :id => :answer3_1
    choose "1", :id => :answer4_1  
    click_on "Save"     
    visit logout_path
    visit login_path
    fill_in "watiam", with: @m.watiam
    fill_in "password", with: @m.password
    click_on "Login"
    visit team_health_path(@team)
    assert_text "Completed Weekly Survey"
    assert_text "No", count: 3
    assert_text "Yes", count: 1   
  end

    # Team Health history should be in the team health page for managers only
    # Story: Manager can see previous weeks team health on team dashboard, as well as this week
  test "manager team list includes team health history" do 
    setup_tickets   
    @m = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users] 
    @team.managers << [@manager]
    visit login_path
    fill_in "watiam", with: @user_3.watiam
    fill_in "password", with: @user_3.password
    click_on "Login"
    click_on "Team 1"
    click_on "Weekly Surveys"
    click_on "Save" 
    visit logout_path
    visit login_path
    fill_in "watiam", with: @m.watiam
    fill_in "password", with: @m.password
    click_on "Login"
    visit team_health_path(@team)
    assert_text "Team Health History"
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
    click_on "Save and View Team"
    assert_text "Health Metrics"
  end
    
  test "editing a team name" do 
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Edit Team"
    fill_in "Name", with: "Team 2" 
    click_on "Update Team Name"
    assert_text "Team name was successfully updated."
    assert_text "Editing Team 2"
  end
    
  test "add member to team" do 
    user2 = User.create(watiam: "bob123", first_name: "Bob", last_name: "Patter", password: "Password")
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Edit Team"
    click_on "Add User"
    assert_text "Successfully added Bob to Team 1"
  end
  
  test "removing member from team" do 
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Edit Team"
    click_on "Remove User"
    assert_text "Successfully removed Joe from Team 1"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "does popup instructions work on team view" do 
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "does popup instructions work on edit team view" do 
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Edit Team"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "does popup instructions work on adding new members view" do 
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on "Team 1"
    click_on "Edit Team"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "do popup instructions work on adding members to a new team" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit manager_dashboard_path
    click_on 'New Team'
    assert_text 'New Team'
    fill_in "Name", with: @team.name
    click_on "Continue to Adding Members"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "do popup instructions work on user team view" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit user_dashboard_path
    click_on "Team 1"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
end
