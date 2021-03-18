class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(:date, :user_id, :team_id)
    end
end
