require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  
  #team validations tests
  test "Should successfully create a team with a valid name" do
    assert @team = Team.create(name: "Team 3").valid?
  end
  
  test "Should fail to create a team with a blank name" do
    assert_not @team = Team.create(name: "").valid?
  end
  
  test "Should fail to create a team with a null name" do
    assert_not @team = Team.create(name: nil).valid?
  end
  
  test "Should fail to create a team with a too long name" do
    assert_not @team = Team.create(name: "This is a team name that is way too long and should be so much shorter").valid?
  end
  
  test "Should fail to create a team with just whitespace for its name" do
    assert_not @team = Team.create(name: "          ").valid?
  end
    
  #get_survey_completion_ratio 
  test "should return ratio of users who have completed surveys for specific team" do
    setup_tickets      
    @team = Team.create(name: "Team 1") 
    users = [@user_1, @user_2, @user_3, @user_4]
    @team.users << [users]    
    current_survey_due_date = Date.new(2021,3,20) 
      
    for i in 0..3 do 
      Survey.create(user_id: users[i].id, team_id: @team.id, date: current_survey_due_date)
    end
    
    # no users have responded to the survey yet    
    assert_equal "0/4", @team.get_survey_completion_ratio(current_survey_due_date)
      
    survey = Survey.find_by(user_id: @user_4.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # only user 4 has responded to the survey   
    assert_equal "1/4", @team.get_survey_completion_ratio(current_survey_due_date) 
      
    survey = Survey.find_by(user_id: @user_2.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    survey = Survey.find_by(user_id: @user_3.id)
    Response.create(survey_id: survey.id, question_number: 1, answer: 1)
    
    # user 2, user 3 and user 4 have responded to the survey     
    assert_equal "3/4", @team.get_survey_completion_ratio(current_survey_due_date) 
  end
    
  #weekly_survey_team_health
  test "should return the correct survey team health for selected week" do
    setup_tickets
    current_date = Date.new(2021,3,20)
      
    s = Survey.create(team_id: @team_1.id, user_id: @user_1.id, date: current_date)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 4)
    end      
    s = Survey.create(team_id: @team_1.id, user_id: @user_2.id, date: current_date)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 3)
    end     
    s = Survey.create(team_id: @team_1.id, user_id: @user_3.id, date: current_date)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 5)
    end
      
    #should get the current week's weekly survey average  
    assert_equal '%.2f' % (80.00), @team_1.weekly_survey_team_health(0, current_date)

    two_weeks_ago = Date.new(2021,3,6)
    s = Survey.create(team_id: @team_1.id, user_id: @user_1.id, date: two_weeks_ago)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 1)
    end      
    s = Survey.create(team_id: @team_1.id, user_id: @user_2.id, date: two_weeks_ago)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 2)
    end     
    s = Survey.create(team_id: @team_1.id, user_id: @user_3.id, date: two_weeks_ago)
    for i in 1..4 do
      Response.create(survey_id: s.id, question_number: i, answer: 5)
    end
      
    #should get two weeks ago weekly survey average  
    assert_equal '%.2f' % (53.33), @team_1.weekly_survey_team_health(2, current_date)

  end
    
  #weekly_feedback_team_health
  test "should return the correct feedback team health for selected week" do
    setup_tickets
    current_date = Date.new(2021,3,20)
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_1.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_1.id, question_number: 5, answer: 8)       
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_2.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_2.id, question_number: 5, answer: 6)     
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_3.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_3.id, question_number: 5, answer: 7)  
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_4.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_4.id, question_number: 5, answer: 10)  
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_5.id, question_number: i, answer: 4)
    end  
    TicketResponse.create(ticket_id: @t_5.id, question_number: 5, answer: 9)       
      
    #should get the current week's weekly feedack average  
    assert_equal '%.2f' % (70.00), @team_1.weekly_feedback_team_health(0, current_date)
    assert_equal '%.2f' % (85.00), @team_2.weekly_feedback_team_health(0, current_date)
      
    @t_1 = Ticket.create(creator_id: @user_1.id, date:"4/03/2021", team_id: @team_1.id)
    @t_2 = Ticket.create(creator_id: @user_1.id, date:"5/03/2021", team_id: @team_1.id)
    @t_3 = Ticket.create(creator_id: @user_1.id, date:"6/03/2021", team_id: @team_1.id)
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_1.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_1.id, question_number: 5, answer: 9)       
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_2.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_2.id, question_number: 5, answer: 3)     
    for i in 1..4 do
      TicketResponse.create(ticket_id: @t_3.id, question_number: i, answer: 4)
    end
    TicketResponse.create(ticket_id: @t_3.id, question_number: 5, answer: 7) 
      
    #should get two weeks ago weekly feedack average  
    assert_equal '%.2f' % (60.00), @team_1.weekly_feedback_team_health(2, current_date)
  end
end
