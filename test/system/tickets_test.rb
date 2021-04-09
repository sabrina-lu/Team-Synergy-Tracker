require "application_system_test_case"
require 'test_helper'

class TicketsTest < ApplicationSystemTestCase
  setup do
    setup_tickets_with_responses
  end

    # from users POV
  test "visiting the create ticket form" do
    visit login_path
    fill_in "watiam", with: @user_1.watiam
    fill_in "password", with: @user_1.password
    click_on "Login"
    visit new_team_ticket_url(@team_1)
    assert_text "New Ticket"
  end
    
  test "can access create ticket from team view" do
    visit login_path
    fill_in "watiam", with: @user_1.watiam
    fill_in "password", with: @user_1.password
    click_on "Login"
    click_on "one"
    assert_text "Create A Ticket"
  end
    
  test "can access create ticket from user dashboard" do
    visit login_path
    fill_in "watiam", with: @user_1.watiam
    fill_in "password", with: @user_1.password
    click_on "Login"
    click_on "Create Ticket"
    assert_text "New Ticket"
  end
    
  test "can discard changes and return to dashboard without completing ticket" do
    visit login_path
    fill_in "watiam", with: @user_1.watiam
    fill_in "password", with: @user_1.password
    click_on "Login"
    click_on "one"
    click_on "Create A Ticket"
    click_on "Go Back and Discard Changes"
    assert_text "one Details"
  end
    
    # from managers POV
  test "can successfully view ticket list as a manager" do
    create_ticket(@user_1, @team_1, @user_2)
    visit login_path
    fill_in "watiam", with: @manager_1.watiam
    fill_in "password", with: @manager_1.password
    click_on "Login"
    click_on "View Tickets"
    assert_text "My Team's Tickets"
  end
    
    # can view the details of a ticket and the feedback that a student gave another student
    # Story: Update manager's view of all tickets
  test "can successfully view ticket's details as a manager" do
    create_ticket(@user_1, @team_1, @user_2)
    visit login_path
    fill_in "watiam", with: @manager_1.watiam
    fill_in "password", with: @manager_1.password
    click_on "Login"
    click_on "View Tickets"
    assert_text "Tickets for Current Week"
  end
    
  # unable to view tickets for another team as a manager
  test "unable view ticket's details as a manager of another team" do
    visit login_path
    fill_in "watiam", with: @manager_1.watiam
    fill_in "password", with: @manager_1.password
    click_on "Login"
    visit ticket_path(@t_5)
    assert_text "You do not have permission to view this ticket."
  end
    
# can successfully send a ticket to another student 
# Story: Change ticket creation from textual feedback to peer rating
  test "creating a Ticket" do
    user2 = User.create(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")
    @team_1.users << user2
    visit login_path
    fill_in "watiam", with: @user_1.watiam
    fill_in "password", with: @user_1.password
    click_on "Login"
    visit new_team_ticket_url(@team_1)
    assert_text "New Ticket"
    select "#{user2.full_name_with_watiam}", :from => :users
    click_on "Save"

    assert_text "Ticket was successfully created"
  end
    
  # create test for:cannot create a ticket without adding a member
    
# is redirected when trying to access a create ticket page for a team they are not on
# Story: Bug Bash: Creating a Ticket if you're not on the team
    test "redirect if not on team to create a ticket" do
        user_5 = User.create(watiam: "u5", first_name: "user5", last_name: "five", password: "Password")
        visit login_path
        fill_in "watiam", with: user_5.watiam
        fill_in "password", with: user_5.password
        click_on "Login"
        visit new_team_ticket_url(@team_1)
        assert_text "You do not have permission to create this ticket"
    end
    
# do not allow users to access ticket form when they submitted a ticket to every member on the team for that week
# Story: UI/UX Refresh
    test "cannot access ticket form if user submitted a ticket to every member that week" do
        visit login_path
        fill_in "watiam", with: @user_1.watiam
        fill_in "password", with: @user_1.password
        click_on "Login"
        click_on "Create Ticket"
        select "u2", from: "users"
        click_on "Save"
        click_on "Create Ticket"
        select "u3", from: "users"
        click_on "Save"
        assert_text "Complete"
        click_on "one"
        click_on "Create A Ticket"
        assert_text "Sorry! You have already submitted a ticket for every member on your team this week. You can submit a ticket next week."
    end
    
# do not allow users to access ticket form if they are the only person on the team
# Story: UI/UX Refresh
    test "cannot access ticket form if user is the only person on the team" do
        # setting up data
        team_with_one_user = Team.create(name: "test")
        user = User.create(watiam: "emlin", first_name: "emma", last_name: "lin", password: "Password")
        team_with_one_user.users << [user]
        team_with_one_user.managers << [@manager_1]
        
        visit login_path
        fill_in "watiam", with: user.watiam
        fill_in "password", with: user.password
        click_on "Login"
        assert_text ""
        click_on "test"
        click_on "Create A Ticket"
        assert_text "Sorry! You are the only person on your team. Your manager needs to add more team members before you can send them a ticket!"
    end
end
