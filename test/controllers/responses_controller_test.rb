require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_manager_tickets
  end
    
  test "should create response" do   
    assert_difference('Response.count', 4) do
      post responses_url, params: { survey_id: Survey.all.first.id, num_of_questions: "4", answer1: "4", answer2: "4", answer3: "4", answer4: "4" }
    end
  end

end
