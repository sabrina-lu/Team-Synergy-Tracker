require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
  test "Should successfully create a ticket with each type of type, priority and category" do 
    type_options = ["Conflict", "Positive", "Neutral"]
    category_options = ["Work", "Personal", "Other"]
    priority_options = [1,2,3]
    
    type_options.each do |option1|
      category_options.each do |option2|
        priority_options.each do |option3|
          @t_test = Ticket.create(user_id: @user_1.id, priority: option3, type: option1, category: option2, date: "10/02/2020", description: "d")
      

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
      post tickets_url, params: { ticket: { category: @ticket.category, date: @ticket.date, description: @ticket.description, priority: @ticket.priority, type: @ticket.type, user_id: @ticket.user_id } }
    end

    assert_redirected_to ticket_url(Ticket.last)
  end

  test "should show ticket" do
    get ticket_url(@ticket)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_url(@ticket)
    assert_response :success
  end

  test "should update ticket" do
    patch ticket_url(@ticket), params: { ticket: { category: @ticket.category, date: @ticket.date, description: @ticket.description, priority: @ticket.priority, type: @ticket.type, user_id: @ticket.user_id } }
    assert_redirected_to ticket_url(@ticket)
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete ticket_url(@ticket)
    end

    assert_redirected_to tickets_url
  end
end
