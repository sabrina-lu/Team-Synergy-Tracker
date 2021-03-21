require "application_system_test_case"
require 'test_helper'

class TicketsTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
  end

  test "visiting the create ticket form" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    visit new_team_ticket_url(@team)
    assert_text "New Ticket"
  end
    
  test "can access create ticket from team view" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    click_on "Team 1"
    assert_text "Create A Ticket"
  end
    
  test "can discard changes and return to dashboard without completing ticket" do
    visit login_path
    fill_in "watiam", with: @user.watiam
    fill_in "password", with: @user.password
    click_on "Login"
    click_on "Team 1"
    click_on "Create A Ticket"
    click_on "Go Back and Discard Changes"
    assert_text "Welcome " + @user.first_name + "!"
  end
    

#  test "creating a Ticket" do
#    user2 = User.create(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")
#    @team.users << user2
#    visit login_path
#    fill_in "watiam", with: @user.watiam
#    fill_in "password", with: @user.password
#    click_on "Login"
#    visit new_team_ticket_url(@team)
       
#    select(user2, :from => "Users")
#    fill_in :users, with: user2
#    fill_in "answer1", with: 1
#    fill_in "answer2", with: -1
#    fill_in "answer3", with: 0
#    fill_in "answer4", with: 1
#    fill_in "answer5", with: 10
#    click_on "Create Ticket"

#    assert_text "Ticket was successfully created"
#  end

#  test "updating a Ticket" do
#    visit tickets_url
#    click_on "Edit", match: :first

#    fill_in "Category", with: @ticket.category
#    fill_in "Date", with: @ticket.date
#    fill_in "Description", with: @ticket.description
#    fill_in "Priority", with: @ticket.priority
#    fill_in "Type", with: @ticket.type
#    fill_in "User", with: @ticket.user_id
#    click_on "Update Ticket"

#    assert_text "Ticket was successfully updated"
#    click_on "Back"
#  end

#  test "destroying a Ticket" do
#    visit tickets_url
#    page.accept_confirm do
#      click_on "Destroy", match: :first
#    end

#    assert_text "Ticket was successfully destroyed"
#  end
end
