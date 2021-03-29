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
    assert_text "close"
  end  
    
# story: Modify user dashboard to display team health
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