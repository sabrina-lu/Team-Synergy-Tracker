require "application_system_test_case"
require 'test_helper'

class UsersTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end

  test "create user account" do 
    visit login_path
    click_on "Don't have an account? Sign up here!"
    fill_in "user_watiam", with: "bob123"
    fill_in "user_first_name", with: "Bob"
    fill_in "user_last_name", with: "Patter"
    fill_in "user_password", with: "himynameisbob"
    fill_in "user_password_confirmation", with: "himynameisbob"
    click_on "Create Account"
    assert_text "Account created and logged in."
  end
    
  test "no logout button on login page" do 
    visit login_path
    assert_no_text "Logout"
  end
    
  test "no logout button on create account page" do 
    visit signup_path
    assert_no_text "Logout"
  end 
  
    # can view instructions on how to use the app on every main page
    # Story: Include instructions on both manager and user's dashboard
  test "dashboard instructions work" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit user_dashboard_path
    click_on "Confused?🤔 Get information here!"
    assert_text "Close"
  end  
    
  test "user cannot view tickets" do 
    @user_2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @team.users << @user_2
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    click_on "Create Ticket"
    select "#{@user_2.full_name_with_watiam}"
    click_on "Save"
    visit ticket_path(Ticket.all.first)
    assert_text "You do not have permission to view this ticket."    
  end

# Story: Team Health calculations will now include weekly surveys and ticket ratings
# acceptance criteria:
# 1. algorithm should include both weekly survey and ticket ratings
# 2. 20% for ticket ratings and 80% for weekly surveys
# 3. within the 20% ticket responses, each responses should be weighed 10% while the ratings is weighed 60%
  test "tickets affect algorithm" do 
    @user_2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @team.users << @user_2
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    click_on "Create Ticket"
    select "#{@user_2.full_name_with_watiam}"
    click_on "Save"
    assert_text "46.00%"
    click_on "Incomplete"
    click_on "Save"
    assert_text "25.20%"
  end     
    
# Story: Modify user dashboard to display team health
# acceptance criteria:
# 1. team health value is the current week team health
# 2. user can view current team health value right away
  test "user dashboard should display team health" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    assert_text "Current Weekly Health"
    click_on "Incomplete"
    click_on "Save"
    assert_text "20.00%"
  end

end