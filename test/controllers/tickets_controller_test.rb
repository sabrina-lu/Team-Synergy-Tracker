require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
  # create ticket tests  
  test "Should successfully create a ticket with each type of type, priority and category" do 
    assert_difference('Ticket.count', 3) do
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_4.priority, type: @t_4.type, category: @t_4.category, date: @t_4.date, description: @t_4.description}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_5.priority, type: @t_5.type, category: @t_5.category, date: @t_5.date, description: @t_5.description}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_6.priority, type: @t_6.type, category: @t_6.category, date: @t_6.date, description: @t_6.description}}
    end
  end  
  
  # show ticket tests  
  test "should redirect user to show ticket if they are involved in the ticket" do
    login_as_user(@user_1)
    get ticket_url(@t_1)
    assert_response :success
  end
  
  test "should redirect user to user tickets when accessing a ticket that they are not involved in" do
    login_as_user(@user_3)
    get ticket_url(@t_2)
    assert_redirected_to user_tickets_url
    assert_equal "You do not have permission to view this ticket.", flash[:notice]
  end
    
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

  test "should update ticket" do
    patch ticket_url(@t_1), params: { ticket: { category: @t_1.category, date: @t_1.date, description: @t_1.description, priority: @t_1.priority, type: @t_1.type, creator_id: @t_1.creator_id } }
    assert_redirected_to ticket_url(@t_1)
  end

end
