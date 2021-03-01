require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    
  test "should return false if user did not create response" do
    setup  
    puts "#{@user.first_name}_________________________________"
    puts "#{@survey.id}_________________________________"
     puts "#{@response.id}_________________________________"
    assert_equal false, Response.permission_to_response(2, @user)
  end
  
    
  def setup 
    @user = User.new(watiam: "jellen", first_name: "Joe", last_name: "Ellen", password: "Password") 
    @user.save
    @survey = Survey.new(id: 1, user_id: 1, team_id: 1)
    @survey_no_access = Survey.new(id: 2, user_id: 2, team_id: 1)
    @survey_no_access_2 = Survey.new(id: 3, user_id: 2, team_id: 2)
    @survey.save
    @survey_no_access.save
    @survey_no_access_2.save
    
    @response = Response.new(id: 1, survey_id: 1, question_number: 1, answer: 5)
    @response_no_access = Response.new(id: 2, survey_id: 2, question_number: 1, answer: 3)
    @response_no_access_2 = Response.new(id: 3, survey_id: 3, question_number: 1, answer: 1)
      
    @response.save
    @response_no_access.save
    @response_no_access_2.save
  end
  
end
