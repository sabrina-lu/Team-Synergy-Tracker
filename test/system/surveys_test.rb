require "application_system_test_case"

class SurveysTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
    @team_no_access.users << @user
    @team_no_access.managers << @manager
    Survey.create(team_id: @team.id, user_id: @user.id, date: Date.new(2021,3,13))
    Survey.create(team_id: @team_no_access.id, user_id: @user.id, date: Date.new(2021,3,13))
  end
  
  test "should be able to visit weekly survey page" do
    login(@manager)
    click_on "Generate Next Week's Surveys"   
    visit logout_path
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys" 
    assert_text "WEEKLY SURVEYS"
  end
    
  test "should be able to submit a survey" do
    login(@manager)
    click_on "Generate Next Week's Surveys"   
    visit logout_path
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    click_on "Save"   
    assert_text "Successfully submitted weekly survey."
  end
    
  test "should be redirect to user dashboard after submitting a survey" do
    login(@manager)
    click_on "Generate Next Week's Surveys"   
    visit logout_path
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    click_on "Save"   
    assert_text "Welcome #{@user.first_name}"
  end
  
  test "should be able to generate next week's surveys as a manager" do
    login(@manager)
    click_on "Generate Next Week's Surveys"    
    assert_text "Weekly Survey Has Been Updated."
  end
    
  test "should redirect manager to manager dashboard when trying to visit weekly survey" do
    login(@manager)
    visit weekly_surveys_path(@team)
    assert_text "Welcome #{@manager.first_name}"
    assert_text "You do not have permission to respond to surveys."
  end
    
  def login(user)
    visit login_path
    fill_in "watiam", with: user.watiam
    fill_in "password", with: user.password
    click_on "Login"  
  end

end
