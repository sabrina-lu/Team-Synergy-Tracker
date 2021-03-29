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

    # can view all the tickets of all the students they manage in a nice list
    # Story: Update manager's view of all tickets
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
    assert_text "1/4"
  end
  
    # can successfully view ticket ratings
  test "can view team's ticket ratings" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View All Tickets"
    assert_text "Rating"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "can dashboard view popup instructions" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "Confused?🤔 Get information here!"
    assert_text "close"
  end
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "can view all tickets view popup instructions" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View All Tickets"
    click_on "Confused?🤔 Get information here!"
    assert_text "close"
  end
end
