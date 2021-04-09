require 'simplecov'
SimpleCov.start 'rails'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
 
  def setup_users_manager_teams
    @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.create(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")       
    @team = Team.create(name: "Team 1")
    @team_no_access = Team.create(name: "Team 5")
      
    @team.users << @user
    @team.managers << @manager
    Survey.create(team_id: @team.id, user_id: @user.id, date: Date.new(2021,3,13))
  end
  
  def setup_tickets
    @manager_1 = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @manager_2 = Manager.create(watiam: "gpaul", first_name: "George", last_name: "Paul", password: "Password")
      
    @user_1 = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "Password")
    @user_2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @user_3 = User.create(watiam: "u3", first_name: "user3", last_name: "three", password: "Password")
    @user_4 = User.create(watiam: "u4", first_name: "user4", last_name: "four", password: "Password")
    
    @team_1 = Team.create(name: "one")
    @team_2 = Team.create(name: "two")
     
    @team_1.users << [@user_1, @user_2, @user_3]
    @team_2.users << [@user_2, @user_3, @user_4]
    @team_1.managers << [@manager_1]
    @team_2.managers << [@manager_2]
   
    @t_1 = Ticket.create(creator_id: @user_1.id, date:"13/03/2021", team_id: @team_1.id)
    @t_2 = Ticket.create(creator_id: @user_1.id, date:"14/03/2021", team_id: @team_1.id)
    @t_3 = Ticket.create(creator_id: @user_2.id, date:"15/03/2021", team_id: @team_2.id)    
    @t_4 = Ticket.create(creator_id: @user_4.id, date: "19/03/2021", team_id: @team_2.id)
    @t_5 = Ticket.create(creator_id: @user_4.id, date: "20/03/2021", team_id: @team_2.id)
    
    @t_1.users << [@user_3]
    @t_2.users << [@user_2]
    @t_3.users << [@user_3]   
    @t_4.users << [@user_3]
    @t_5.users << [@user_2] 
  end
    
  def setup_tickets_with_responses
    @manager_1 = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @manager_2 = Manager.create(watiam: "gpaul", first_name: "George", last_name: "Paul", password: "Password")
      
    @user_1 = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "Password")
    @user_2 = User.create(watiam: "u2", first_name: "user2", last_name: "two", password: "Password")
    @user_3 = User.create(watiam: "u3", first_name: "user3", last_name: "three", password: "Password")
    @user_4 = User.create(watiam: "u4", first_name: "user4", last_name: "four", password: "Password")
    
    @team_1 = Team.create(name: "one")
    @team_2 = Team.create(name: "two")
     
    @team_1.users << [@user_1, @user_2, @user_3]
    @team_2.users << [@user_2, @user_3, @user_4]
    @team_1.managers << [@manager_1]
    @team_2.managers << [@manager_2]
   
    @t_1 = Ticket.create(creator_id: @user_1.id, date:"13/03/2021", team_id: @team_1.id)
    @t_2 = Ticket.create(creator_id: @user_1.id, date:"14/03/2021", team_id: @team_1.id)
    @t_3 = Ticket.create(creator_id: @user_2.id, date:"15/03/2021", team_id: @team_2.id)    
    @t_4 = Ticket.create(creator_id: @user_4.id, date: "19/03/2021", team_id: @team_2.id)
    @t_5 = Ticket.create(creator_id: @user_4.id, date: "20/03/2021", team_id: @team_2.id)
      
    t = [@t_1, @t_2, @t_3, @t_4, @t_5]
    for i in 0..4
        TicketResponse.create(ticket_id: t[i].id, question_number: 1, answer: 1)
        TicketResponse.create(ticket_id: t[i].id, question_number: 2, answer: 2)
        TicketResponse.create(ticket_id: t[i].id, question_number: 3, answer: 3)
        TicketResponse.create(ticket_id: t[i].id, question_number: 4, answer: 2)
        TicketResponse.create(ticket_id: t[i].id, question_number: 5, answer: 7)
    end
    
    @t_1.users << [@user_3]
    @t_2.users << [@user_2]
    @t_3.users << [@user_3]   
    @t_4.users << [@user_3]
    @t_5.users << [@user_2] 
  end
  
  def setup_user_for_tickets_models
    @user_4 = User.create(watiam: "u4", first_name: "user4", last_name: "four", password: "Password")
  end
    
  def setup_surveys_responses
    @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.create(watiam: "jbob", first_name: "Joe", last_name: "Bob", password: "Password")     
    @user_2 = User.create(watiam: "naccess", first_name: "no", last_name: "access", password: "Password")
      
    @team = Team.create(name: "Team 1")
    @team_no_access = Team.create(name: "Team 5")
      
    add_member_to_team_and_survey(@team, @user.id)
    add_member_to_team_and_survey(@team_no_access, @user_2.id)
    @team.managers << @manager
    
    Survey.all.each do |x|
        x.responses << Response.create(question_number: 1, answer: "1")
    end
  end
  
  def setup_baseline_for_survey_models
    @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.create(watiam: "jbob", first_name: "Joe", last_name: "Bob", password: "Password")     
    @user_2 = User.create(watiam: "naccess", first_name: "no", last_name: "access", password: "Password")
      
    @team = Team.create(name: "Team 1")
    @team_no_access = Team.create(name: "Team 5")
      
    add_member_to_team_and_survey(@team, @user.id)
    add_member_to_team_and_survey(@team_no_access, @user_2.id)
    @team.managers << @manager
  end
    
  def login_as_manager(manager = @manager)
    post login_path, params: { watiam: manager.watiam, password: manager.password }
  end
 
  def login_as_user(user = @user)
    post login_path, params: { watiam: user.watiam, password: user.password }
  end
    
  def add_member_to_team_and_survey(team, user_id)
    post confirm_add_member_path(team), params: { user_id: user_id }
  end
    
  def create_ticket(user, team, user2)
    visit login_path
    fill_in "watiam", with: user.watiam
    fill_in "password", with: user.password
    click_on "Login"
    visit new_team_ticket_url(team)
    select "#{user2.full_name_with_watiam}", :from => :users
    click_on "Save"
    visit logout_path
  end
    
end
