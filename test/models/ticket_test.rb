require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  setup do
    setup_user_for_tickets_models
  end
  
  test "Should fail to create a ticket with no description" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 1, type: "Conflict", category: "Other", date: "12/02/2020", description: nil).valid?
  end
  
  test "Should fail to create a ticket with too long description 501 characters" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 1, type: "Conflict", category: "Other", date: "12/02/2020", description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus").valid?
  end
  
  test "Should successfully create a ticket with 500 character description" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 1, type: "Conflict", category: "Other", date: "12/02/2020", description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibu").valid?
  end
  
  test "Should successfully create a ticket with 1 character description" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 1, type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should successfully create a ticket with 1 priority" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 1 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should successfully create a ticket with 2 priority" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 1 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should successfully create a ticket with 3 priority" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 1 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with nil priority" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: nil , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with undefined priority" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 0 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with negative priority" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: -1 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with large undefined priority" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 30 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with undefined type" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "wrong", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with type with wrong formatting" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with nil type" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: nil, category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should successfully create a ticket with valid type" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with undefined category" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "Conflict", category: "wrong", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with category with wrong formatting" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "Conflict", category: "other", date: "12/02/2020", description: "C").valid?
  end
  
  test "Should fail to create a ticket with nil category" do
    assert_not @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "Conflict", category: nil, date: "12/02/2020", description: "C").valid?
  end
  
  test "Should successfully create a ticket with valid category" do
    assert @ticket = Ticket.new(creator_id: @user_4.id, priority: 2 , type: "Conflict", category: "Other", date: "12/02/2020", description: "C").valid?
  end
  
end
