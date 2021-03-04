class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  def create
    manager = Manager.find(params[:manager_id])
    next_survey_due_date = Survey.get_next_survey_due_date(Date.today)
    manager.teams.each do |team|
      team.users.each do |user|
        Survey.create(user_id: user.id, team_id: team.id, date: next_survey_due_date)
      end
    end
    redirect_to manager_dashboard_url, notice: 'Weekly Survey Has Been Updated.'

  end

  # PATCH/PUT /surveys/1
  def update
    if @survey.update(survey_params)
      redirect_to @survey, notice: 'Survey was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: 'Survey was successfully destroyed.'
  end

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
