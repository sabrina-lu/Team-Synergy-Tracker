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
    visit logout_path
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
    choose "2", :id => :answer1_2
    choose "2", :id => :answer2_2
    choose "3", :id => :answer3_3
    choose "4", :id => :answer4_4
    click_on "Save"

    assert_text "Successfully submitted weekly survey."
  end
    
  test "creating an invalid Response" do
    visit user_dashboard_url
    click_on "Incomplete"
    choose "4", :id => :answer4_4
    click_on "Save"

    assert_text "Invalid survey response score. Please fix and re-submit."
  end
end
