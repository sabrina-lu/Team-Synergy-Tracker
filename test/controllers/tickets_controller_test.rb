require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
#   create ticket tests  
   test "Should successfully create a ticket" do 
     assert_difference('Ticket.count', 1) do
       assert_difference('TicketResponse.count', 5) do
           post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, date: @t_4.date, users: ["", @user_1.id], answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}  
       end
     end
   end
    
  test "Should successfully redirect user to their dashboard after ticket creation" do
    post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, date: @t_4.date, users: ["", @user_1.id], answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}
    assert_redirected_to user_dashboard_url
  end
    

#   TODO:FIX THESE TEST AFTER IMPLEMENTING CREATE TICKET FORM
   test "Should successfully create a ticket with no users" do
       assert_difference('Ticket.count',1) do
           @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
           post create_team_ticket_url(@team_1), params: {creator_id: @user_4.id, users: [], date: @t_5.date, answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5 }   
       end
   end


#   test "Should successfully create a ticket with a user" do
#       @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
#       post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [@user_1.id], date: @t_5.date}}   
#       assert_equal(false, Ticket.all.last.users.where(id: @user_1.id).nil?)
#   end
    
#   test "Should successfully create a ticket with multiple users" do
#       @user = User.create(watiam: "Disney", first_name: "Mickey", last_name: "Mouse", password: "Test") 
#       @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
#       post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [@user_1.id, @user.id], date: @t_5.date}}   
#       assert_equal(false, Ticket.all.last.users.where(id: @user.id).nil?)
#   end

   test "Should fail to create a ticket with invalid user" do
       assert_raise do
                 post create_team_ticket_url, params: {creator_id: @user_4.id, users: 0, date: @t_5.date, answer1: 1, answer2: 2, answer3: 3, answer4: 4, answer5: 5}   
       end
   end
    
#   TODO:FIX TESTS TO NEW REQUIREMENTS (USER CANNOT SEE TICKETS)
   
  
#   test "should redirect user to user tickets when accessing a ticket that they are not involved in" do
#     login_as_user(@user_3)
#     get ticket_url(@t_2)
#     assert_redirected_to user_tickets_url
#     assert_equal "You do not have permission to view this ticket.", flash[:notice]
#   end
    
   test "should show manager any ticket they want to view" do
     @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
     login_as_manager
     get ticket_url(@t_1)
     assert_response :success
     get ticket_url(@t_2)
     assert_response :success
     get ticket_url(@t_3)
     assert_response :success
   end

    
  test "should redirect manager to show ticket when accessing edit ticket" do
      @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
      login_as_manager
      get edit_ticket_url(@t_1)
      assert_redirected_to ticket_url(@t_1)
      assert_equal "You do not have permission to edit this ticket.", flash[:notice]
  end
end
