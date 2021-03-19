require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_tickets
  end
  
#   create ticket tests  
  test "Should successfully create a ticket with each type of type, priority and category" do 
    assert_difference('Ticket.count', 3) do
      post tickets_url, params: {ticket: {creator_id: @user_4.id, date: @t_4.date}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, date: @t_5.date}}
      post tickets_url, params: {ticket: {creator_id: @user_4.id, date: @t_6.date}}
    end
  end  

  test "Should successfully create a ticket with no users" do
      assert_difference('Ticket.count',1) do
          @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
          post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [], date: @t_5.date}}   
      end
  end
    
  test "Should successfully create a ticket with a user" do
      @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
      post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [@user_1.id], date: @t_5.date}}   
      assert_equal(false, Ticket.all.last.users.where(id: @user_1.id).nil?)
  end
    
  test "Should successfully create a ticket with multiple users" do
      @user = User.create(watiam: "Disney", first_name: "Mickey", last_name: "Mouse", password: "Test") 
      @user_1 = User.create(watiam: "DisneyPL", first_name: "Mickey", last_name: "Mouse", password: "Test") 
      post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [@user_1.id, @user.id], date: @t_5.date}}   
      assert_equal(false, Ticket.all.last.users.where(id: @user.id).nil?)
  end

  test "Should fail to create a ticket with invalid user" do
      assert_raise do
                post tickets_url, params: {ticket: {creator_id: @user_4.id, users: [@user_blank.id], date: @t_5.date}}   
      end
  end
   
#   show ticket tests  
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
    patch ticket_url(@t_1), params: { ticket: { date: @t_1.date, creator_id: @t_1.creator_id } }
    assert_redirected_to ticket_url(@t_1)
  end
    
  test "should redirect manager to show ticket when accessing edit ticket" do
      @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
      login_as_manager
      get edit_ticket_url(@t_1)
      assert_redirected_to ticket_url(@t_1)
      assert_equal "You do not have permission to edit this ticket.", flash[:notice]
  end
end
