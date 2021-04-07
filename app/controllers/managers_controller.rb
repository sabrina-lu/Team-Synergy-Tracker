class ManagersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_manager, only: [:show, :edit, :update, :destroy] # this was og the other two were randomly added to match user and havent been tested yet ¯\_(ツ)_/¯
  before_action :authorized_to_modify_and_destroy, only: [:edit, :update, :destroy]

  # GET /managers/new
  def new
    manager_params = params
    @manager = Manager.new
    if manager_params[:flag] == "Manager"
      @manager = Manager.create
    end
  end
    
  # GET /manager_dashboard
  def dashboard
    @manager = current_user_is_manager
    if !@manager
        redirect_to_manager_login
    else
      @CURRENT_SURVEY_DUE_DATE = CURRENT_SURVEY_DUE_DATE
    end 
  end
  
  # GET /team_health/1/metrics
  def team_health
    @CURRENT_SURVEY_DUE_DATE = CURRENT_SURVEY_DUE_DATE
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @team = Team.find(params[:id])
    if !current_user_is_on_team(@team)
        redirect_to manager_dashboard_path, notice: 'You do not have permission to view this team.'
    else
      @team_health = true
      @team_users = @team.users
      @users = User.get_ordered_survey_indicator(@team, CURRENT_SURVEY_DUE_DATE) 
      @team_health_history = @team.get_health_history(CURRENT_SURVEY_DUE_DATE) 
        
      if Response.where(survey_id: Survey.where(team_id: @team.id)).exists?
        @any_team_health_history = true
      else
        @any_team_health_history = false
      end
        
      if @team_health_history.present?
        @health_value = @team_health_history[0][6] 
      else 
        @health_value = 0
      end
    end
  end

  # POST /managers
  def create    
    if manager_params[:flag] == "Manager"
      @manager = Manager.new(manager_params)
    else
      @manager = User.new(manager_params) 
    end
    @userCannotBeCreated = false
    @watiamList = User.select("watiam") + Manager.select("watiam")
    @watiamList.each do |x|
        if @manager.watiam == x.watiam
            @userCannotBeCreated = true
        end
    end
    if @userCannotBeCreated == false
        if @manager.save
          log_in @manager
          redirect_to root_url, notice: 'Account created and logged in.'
        else
          render :new
        end
    else
        flash[:alert] = "That WATIAM has an account associated with it already"
        render :new
    end
  end
    
  def tickets
    @team = Team.find(params[:id])
    @tickets = []
    if current_user_is_manager
      @tickets = Ticket.where(team_id: params[:id]).order("date DESC")
    else
      redirect_to user_dashboard_path, notice: "You do not have permission to view tickets." 
    end
  end
    
  def surveys
    q1 = "How do you feel about this week in comparison to last week?"
    q2 = "How did you feel about this week?"
    q3 = "How would you rate your communication with your team members this week?"
    q4 = "How do you feel about the workload you had this week?"
    @questions = [q1,q2,q3,q4]

    due_date = Date.parse(params[:date])
    @interval = "#{due_date-7} - #{due_date-1}"
    if due_date == @CURRENT_SURVEY_DUE_DATE
        @current_week = true
    else
        @current_week = false
    end
      
    @team = Team.find(params[:id])
    @surveys = []
    if current_user_is_manager
      @surveys = Survey.where(team_id: params[:id], date: params[:date])
    else
      redirect_to user_dashboard_path, notice: "You do not have permission to view surveys." 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manager_params
      params.require(:manager).permit(:name, :flag, :watiam, :password, :first_name, :last_name, :password_confirmation)
    end
end
