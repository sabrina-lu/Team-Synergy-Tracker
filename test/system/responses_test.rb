require "application_system_test_case"

class ResponsesTest < ApplicationSystemTestCase
  setup do
    #setup_surveys_responses
    setup_users_manager_teams
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    
  end

  test "visiting /responses should send user and manager to respective dashboard" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit responses_url
    has_current_path? user_dashboard_path
    visit logout_path
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    visit responses_url
    has_current_path? manager_dashboard_path
  end

  test "creating a Response" do
    visit user_dashboard_url
    click_on "Incomplete"
    select "2", :from => :answer1
    select "2", :from => :answer2
    select "3", :from => :answer3
    select "4", :from => :answer4
    click_on "Save"

    assert_text "Successfully submitted weekly survey."
  end
end
