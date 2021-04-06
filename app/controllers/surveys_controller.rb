class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  def show
    survey = Survey.find(params[:id])
    responses = []
    responses = Response.where(:survey_id => survey.id).order(:question_number)
    @responses = []
    for i in 0..responses.length - 1 
        @responses << responses[i].answer
    end
      
    if !current_user_is_manager
        redirect_to user_dashboard_path, notice: "You do not have permission to view this survey."
    elsif !current_user.teams.include?(survey.team)
        redirect_to manager_dashboard_path, notice: "You do not have permission to view this survey."
    end
  end

  private
    def set_survey
      @survey = Survey.find(params[:id])
    end
end
