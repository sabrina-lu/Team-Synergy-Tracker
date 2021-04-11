require "application_system_test_case"

class Static_PagesTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end
  
  test "user about page works" do
    @user = User.create(watiam: "u", first_name: "user", last_name: "user", password: "Password")
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    
    visit about_url
    has_current_path? user_dashboard_path
    click_on "Return to Dashboard"
  end
    
   test "manager about page works" do
    @manager = Manager.create(watiam: "m", first_name: "manager", last_name: "mgmt", password: "Password")
    visit login_path
    fill_in "watiam", with: @manager.watiam
    fill_in "password", with: @manager.password
    click_on "Login"
    
    visit about_url
    has_current_path? user_dashboard_path
    click_on "Return to Dashboard"
  end
  
end
