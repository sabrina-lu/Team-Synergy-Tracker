require "application_system_test_case"
require 'test_helper'

class ManagersTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end
  
  test "create manager account" do 
    visit login_path
    click_on "Don't have an account? Sign up here!"
    choose(option: 'Manager')
    fill_in "user_watiam", with: "tom123"
    fill_in "user_first_name", with: "Tom"
    fill_in "user_last_name", with: "Tim"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Create Account"
    assert_text "Account created and logged in."
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
    assert_text "Cannot log you in. Invalid Watiam or Password."
  end
    
    # login with wrong watiam
  test "login with password that doesn't match" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: "blah"
    click_on "Login"
    assert_text "Cannot log you in. Invalid Watiam or Password."
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
      
    # If the team has no health history, a message should be displayed in place of the table
  test "display message for no team health history" do
    @team_no_members = Team.create(name: "Team No Members")
    @team_no_members.managers << @manager
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit team_health_path(@team_no_members)
    assert_text "No historical data available"
  end
    
    # Story: Add team health breakdown
  test "should show different categories for team health history" do
    @team_no_members = Team.create(name: "Team No Members")
    @team_no_members.managers << @manager
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    click_on "Incomplete"
    click_on "Save"
    visit logout_path
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit team_health_path(@team)
    assert_text "Communication"
    assert_text "Behaviour"
    assert_text "Teamwork"
    assert_text "Availability"
    assert_text "Weekly Surveys"
    assert_text "Team Health"
  end
    
    # can view the tickets of each team they manage in a nice list
    # Story: Display view of all tickets in an organized way for manager
  test "can view team's tickets" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View Tickets"
    assert_text "Team 1's Tickets"
  end

    # On the manager dashboard there should be ratio of the students who completed weekly surveys for each team
    # Story: Manager can see which users did not complete weekly survey
  test "manager dashboard can view weekly survey completion ratio" do 
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
    assert_text "1/4"
  end
  
    # can successfully view ticket ratings
  test "can view team's ticket ratings" do
    @user2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @team.users << @user2
    @t_1 = Ticket.create(creator_id: @user.id, date:"13/03/2021", team_id: @team.id)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 1, answer: 1)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 2, answer: 2)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 3, answer: 3)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 4, answer: 2)
    TicketResponse.create(ticket_id: @t_1.id, question_number: 5, answer: 7)
    @t_1.users << [@user2]
    
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View Tickets"
    assert_text "Rating"
  end
  
  test "ticket view when team has no tickets" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View Tickets"
    assert_text "This team did not create any tickets"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "can dashboard view popup instructions" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "can view tickets view popup instructions" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View Tickets"
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end
    
    # if there are no members on a team, add a message to let the manager know to add them
    # Story: UI/UX Refresh
  test "display message for no team members on the team view" do
      empty_team = Team.create(name: "Team No Members")
      empty_team.managers << @manager
      visit login_path
      fill_in "watiam", with: @manager.watiam
      fill_in "password", with: @manager.password
      click_on "Login"
      click_on "Team No Members"
      assert_text "This team has no members. Let's start tracking this team's health by adding members. Edit Team below!"
  end 
    
# Story: UI/UX Refresh
# acceptance criteria:
# 1. logo redirects manager to manager dashboard when clicked
  test "should redirect manager to manager dashboard when clicking on logo" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "Team 1"
    click_link "logo"
    assert_text "Welcome #{@manager.first_name}"
  end
end
