ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start
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
  end
    
  def setup_surveys_responses
    @manager = Manager.create(watiam: "jsmith", first_name: "John", last_name: "Smith", password: "Password")
    @user = User.create(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password")     
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
    
  def login_as_manager
    post login_path, params: { watiam: @manager.watiam, password: @manager.password }
  end
 
  def login_as_user
    post login_path, params: { watiam: @user.watiam, password: @user.password }
  end
    
  def add_member_to_team_and_survey(team, user_id)
    post confirm_add_member_path(team), params: { user_id: user_id }
  end
end
