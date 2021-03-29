require "application_system_test_case"

class TicketResponsesTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
  end
    
    # can select "poor", "typical", "great"
    # Story: Change ticket creation from textual feedback to peer rating
  test "creating a ticket response" do 
    user2 = User.create(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")
    @team.users << user2
    visit new_team_ticket_url(@team)
    select "jellen: Joe Ellen", :from => :users
    select "great", :from => :answer1
    select "poor", :from => :answer2
    select "typical", :from => :answer3
    select "great", :from => :answer4
    select "9", :from => :answer5
    click_on "Save"
    assert_text "Ticket was successfully created"
  end
end
