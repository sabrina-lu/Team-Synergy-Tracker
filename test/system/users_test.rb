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
end
