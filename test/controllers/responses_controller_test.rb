require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
  end
    
  test "should create response" do  
    @user_1 = User.create(watiam: "user1", password: "Password", first_name: "user", last_name: "one")
    @team_1 = Team.create(name: "Team 1")
    add_member_to_team_and_survey(@team_1, @user_1.id)
    survey = Survey.find_by(user_id: @user_1.id)
    assert_difference('Response.count', 4) do
      post responses_url, params: { survey_id: survey.id, num_of_questions: "4", answer1: "4", answer2: "4", answer3: "4", answer4: "4" }
    end
  end

end
