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

  # Should not be accessable
  # test modified from https://stackoverflow.com/a/4804354/12816127
  test "visiting the index" do
    assert_raises(ActionController::RoutingError) do
      visit responses_url
    end
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

  test "updating a Response" do
    assert_raises(ActionController::RoutingError) do
      visit responses_url
    end
  end

  test "destroying a Response" do
    assert_raises(ActionController::RoutingError) do
      visit responses_url
    end
  end
end
