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
