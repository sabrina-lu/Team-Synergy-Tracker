require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
#   create ticket tests  
   test "Should successfully create a ticket" do 
     assert_difference('Ticket.count', 1) do
       assert_difference('TicketResponse.count', 5) do
           post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, date: @t_4.date, users: [@user_1.id], answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}  
       end
     end
   end
    
  test "Should successfully redirect user to their dashboard after ticket creation" do
    post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, date: @t_4.date, users: [@user_1.id], answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}
    assert_redirected_to user_dashboard_url
  end
    
    test "user should not be able to create a ticket if they are not on that team" do
        user_5 = User.create(watiam: "u5", first_name: "user5", last_name: "five", password: "Password")
        post login_path, params: { watiam: user_5.watiam, password: user_5.password }
        get new_team_ticket_url(@team_1, "dashboard")
        assert_redirected_to user_dashboard_url
    end
    
    test "should not let manager create a ticket" do
      login_as_manager(@manager_1)
      get new_team_ticket_url(@team_1)
      assert_redirected_to manager_dashboard_url
      assert_equal "You do not have permission to create tickets.", flash[:notice]
    end
    
    test "should let user create a ticket" do
      login_as_user(@user_1)
      get new_team_ticket_url(@team_1)
      assert_response :success
    end
    
    test 'should inform user that a user must be added when submitting a ticket with no user selected' do      
      login_as_user(@user_1)
      assert_difference('Ticket.count', 0) do
        assert_difference('TicketResponse.count', 0) do
           post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, date: @t_4.date, answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}  
        end
      end
      assert_equal "You Must Add a User to this Ticket.", flash[:notice]
    end
    
end
