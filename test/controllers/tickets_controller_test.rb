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
        get new_team_ticket_url(@team_1)
        assert_redirected_to user_dashboard_url
    end
    
    test "should not show manager tickets that aren't for their team" do
      @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
      t = [@t_1, @t_2, @t_3]
      for i in 0..2 do
          TicketResponse.create(ticket_id: t[i].id, question_number: 1, answer: 1)
          TicketResponse.create(ticket_id: t[i].id, question_number: 2, answer: 2)
          TicketResponse.create(ticket_id: t[i].id, question_number: 3, answer: 3)
          TicketResponse.create(ticket_id: t[i].id, question_number: 4, answer: 2)
          TicketResponse.create(ticket_id: t[i].id, question_number: 5, answer: 7)
      end      
      login_as_manager
      get ticket_url(@t_1)
      assert_redirected_to manager_dashboard_url
      get ticket_url(@t_2)
      assert_redirected_to manager_dashboard_url
      get ticket_url(@t_3)
      assert_redirected_to manager_dashboard_url
    end
    
    test "should show manager tickets that are for their team" do
      @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
      @team = Team.create(name: "test")
      @team.managers << @manager
        
      @t_1.team = @team  
      @t_2.team = @team
      @t_3.team = @team
        
      TicketResponse.create(ticket_id: @t_1.id, question_number: 1, answer: 1)
      TicketResponse.create(ticket_id: @t_1.id, question_number: 2, answer: 2)
      TicketResponse.create(ticket_id: @t_1.id, question_number: 3, answer: 3)
      TicketResponse.create(ticket_id: @t_1.id, question_number: 4, answer: 2)
      TicketResponse.create(ticket_id: @t_1.id, question_number: 5, answer: 7)
        
      TicketResponse.create(ticket_id: @t_2.id, question_number: 1, answer: 1)
      TicketResponse.create(ticket_id: @t_2.id, question_number: 2, answer: 2)
      TicketResponse.create(ticket_id: @t_2.id, question_number: 3, answer: 3)
      TicketResponse.create(ticket_id: @t_2.id, question_number: 4, answer: 2)
      TicketResponse.create(ticket_id: @t_2.id, question_number: 5, answer: 7)
      
      TicketResponse.create(ticket_id: @t_3.id, question_number: 1, answer: 1)
      TicketResponse.create(ticket_id: @t_3.id, question_number: 2, answer: 2)
      TicketResponse.create(ticket_id: @t_3.id, question_number: 3, answer: 3)
      TicketResponse.create(ticket_id: @t_3.id, question_number: 4, answer: 2)
      TicketResponse.create(ticket_id: @t_3.id, question_number: 5, answer: 7)
        
      login_as_manager
      get ticket_url(@t_1)
      assert_response :success
      get ticket_url(@t_2)
      assert_response :success
      get ticket_url(@t_3)
      assert_response :success
    end
    
end
