require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
  test "Should successfully create a ticket with each type of type, priority and category" do 
    assert_difference('Ticket.count', 3) do
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_4.priority, type: @t_4.type, category: @t_4.category, date: @t_4.date, description: @t_4.description}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_5.priority, type: @t_5.type, category: @t_5.category, date: @t_5.date, description: @t_5.description}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, priority: @t_6.priority, type: @t_6.type, category: @t_6.category, date: @t_6.date, description: @t_6.description}}
    end
  end  
    
#   test "should add user to a ticket" do
#       @user = User.create(watiam: "Disney", first_name: "Mickey", last_name: "Mouse", password: "Test") 
#       @ticket
#       post tickets_url, params: {ticket: {creator_id: @user_4.id, users: @user, priority: @t_5.priority, type: @t_5.type, category: @t_5.category, date: @t_5.date, description: @t_5.description}}
#       assert_equals(@t_4.users, @user)
#   end
  
#   test "Should successfully remove user from ticket" do
     
#   end
    
  test "should get index" do
    get tickets_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_url
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post tickets_url, params: { ticket: { category: @ticket.category, date: @ticket.date, description: @ticket.description, priority: @ticket.priority, type: @ticket.type, creator_id: @ticket.user_id } }
    end

    assert_redirected_to ticket_url(Ticket.last)
  end

  test "should show ticket" do
    get ticket_url(@t_1)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_url(@t_1)
    assert_response :success
  end

  test "should update ticket" do
    patch ticket_url(@t_1), params: { ticket: { category: @t_1.category, date: @t_1.date, description: @t_1.description, priority: @t_1.priority, type: @t_1.type, users: @t_1.users, creator_id: @t_1.creator_id } }
    assert_redirected_to ticket_url(@t_1)
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete ticket_url(@t_1)
    end

    assert_redirected_to tickets_url
  end
end
