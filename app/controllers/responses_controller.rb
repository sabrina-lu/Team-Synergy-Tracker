class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]

  # POST /responses
  def create
    for i in 1..response_params[:num_of_questions].to_i
        @response = Response.new(survey_id: response_params[:survey_id], question_number: i, answer: response_params[:"answer#{i}"])
        @response.save
    end
      
    redirect_to user_dashboard_path, notice: 'Successfully submitted weekly survey.'  
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
