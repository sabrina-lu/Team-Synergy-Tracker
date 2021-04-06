class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]
  
  def new
  end
  
  # POST /responses
  def create
    if answer_not_valid(response_params[:answer1], response_params[:answer2], response_params[:answer3], response_params[:answer4])
      @team = Team.find(Survey.find(response_params[:survey_id]).team_id)
      redirect_to weekly_surveys_path(@team), notice: 'Invalid survey response score. Please fix and re-submit.'
    else
      for i in 1..response_params[:num_of_questions].to_i
        @response = Response.new(survey_id: response_params[:survey_id], question_number: i, answer: response_params[:"answer#{i}"])
        @response.save
      end
      redirect_to user_dashboard_path, notice: 'Successfully submitted weekly survey.'
    end
  end
  
  def answer_not_valid(*args)
      for i in args
        i = i.to_i
        if i < 1 || i > 5
          return true
        end
      end
      return false
    end
   
  private    
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def response_params
      params.permit(:survey_id, :num_of_questions, :answer1, :answer2, :answer3, :answer4)
    end   
end
