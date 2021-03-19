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
    
    # can successfully view ticket ratings
  test "can view team's ticket ratings" do
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    click_on "View All Tickets"
    assert_text "Rating"
  end
    
     # can successfully create a new team with no members
#  test "can create a team with no name" do
#    visit login_path
#    fill_in "watiam", with: @manager.watiam
#    fill_in "password", with: @manager.password
#    click_on "Login"
#    click_on "New Team"
#    fill_in "name", with: "test team"
#    click_on "Continue to Adding Members"
#    click_on "Back"
#    assert_text "Editing Team test team"
#  end
   
#  test "updating a Manager" do
#    visit managers_url
#    click_on "Edit", match: :first

#    fill_in "First name", with: @manager.first_name
#    fill_in "Last name", with: @manager.last_name
#    fill_in "Watiam", with: @manager.watiam
#    click_on "Update Manager"

#    assert_text "Manager was successfully updated"
#    click_on "Back"
#  end

#  test "destroying a Manager" do
#    visit managers_url
#    page.accept_confirm do
#      click_on "Destroy", match: :first
#    end

#    assert_text "Manager was successfully destroyed"
#  end
end
