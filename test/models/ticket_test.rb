require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  setup do
    setup_user_for_tickets_models    
    @team = Team.create(name: "test")
  end

  test "Should fail to create a ticket with invalid user" do
    @ticket = Ticket.create(creator_id: @user_4.id, date: "12/02/2020")
    assert_raise do 
        @ticket.users << [@user_blank]
    end 
  end
  
  test "Should successfully create a ticket with valid users" do
    @user = User.create(watiam: "WaltDisn", first_name: "Mickey", last_name: "Mouse", password: "Testing") 
    @user_1 = User.create(watiam: "Disneypl", first_name: "Minnie", last_name: "Mouse", password: "Testing2") 
    @ticket = Ticket.create(creator_id: @user.id, date: "12/02/2020", team_id: @team.id)
    @ticket.users << [@user_1]
    assert @ticket.users = [@user_1]
  end
    
  test "Should successfully create a ticket with no users" do
    assert @ticket = Ticket.create(creator_id: @user_4.id, date: "12/02/2020", team_id: @team.id).valid?
  end
end
