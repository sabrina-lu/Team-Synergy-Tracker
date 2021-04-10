class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorized_to_modify_and_destroy, only: [:edit, :update, :destroy]
  before_action :check_path, except [:new, :create]
    
  # GET /users/new
  def new
    user_params = params
    @user = User.new
    if user_params[:flag] == "User"
      @user = User.create
    end
  end
    
  # GET /dashboard
  def dashboard
     if current_user_is_manager
         redirect_to manager_dashboard_path
     else
         @CURRENT_SURVEY_DUE_DATE = CURRENT_SURVEY_DUE_DATE
         @user = current_user #get logged in user from session
         @teams = @user.teams
         @survey_completed = {}
         @ticket_completed = {}
         @teams.each do |team| #for each team user is on, check if user completed the survey for that team    
             @survey = Survey.find_by(user_id: current_user.id, team_id: team.id, date: CURRENT_SURVEY_DUE_DATE)
             if !@survey
               @survey = Survey.create(user_id: current_user.id, team_id: team.id, date: CURRENT_SURVEY_DUE_DATE)
               @survey_completed[team] = false
             else
               if @survey and @survey.responses.exists? 
                 @survey_completed[team] = true
               else 
                 @survey_completed[team] = false
               end
             end
             @users_completed_ticket = team.get_users_with_tickets(current_user, CURRENT_SURVEY_DUE_DATE)
             @total_users_on_team = team.users.length
             @users_completed_ticket.length == @total_users_on_team ? @ticket_completed[team] = true : @ticket_completed[team] = false             
         end
         
         @teamHealth = {}
         @teams.each do |team|
             @teamHealth[team] = team.weekly_survey_team_health(0, CURRENT_SURVEY_DUE_DATE)
         end
         
     end
  end
    
  # GET /dashboard/teams/1 
  def team_list
     @team = Team.find(params[:id])
     if current_user_is_manager
         redirect_to team_health_path(@team)
     else
          if !current_user_is_on_team(@team)
              redirect_to user_dashboard_path, alert: 'You do not have permission to view this team.'
          else
              @health_value = @team.get_total_team_health(0, CURRENT_SURVEY_DUE_DATE) 
          end
          @users = @team.users
          @manager = @team.managers.first  #for now only one manager per team
      end
  end
    
  # GET /weekly_surveys/teams/1
  def weekly_surveys
    @from = params[:from]
    @team = Team.find(params[:id])
    if current_user_is_manager
         redirect_to manager_dashboard_path, alert: 'You do not have permission to respond to surveys.'
    elsif !current_user_is_on_team(@team)
         redirect_to user_dashboard_path, alert: 'You do not have permission to respond to another team\'s survey.'
    end
    @survey = Survey.find_by(user: current_user.id, team: @team.id, date: CURRENT_SURVEY_DUE_DATE)
    if @survey && @survey.responses.exists?
      redirect_to user_dashboard_path, notice: "You have already submitted this week's survey."
    end
    q1 = "How do you feel about this week in comparison to last week?"
    q2 = "How did you feel about this week?"
    q3 = "How would you rate your communication with your team members this week?"
    q4 = "How do you feel about the workload you had this week?"
    @questions = [q1,q2,q3,q4]
  end
  
  # POST /users
  def create
    if user_params[:flag] == "User"
      @user = User.new(user_params)
    else
      @user = Manager.new(user_params)
    end
      
    @userCannotBeCreated = false
    @watiamList = User.select("watiam") + Manager.select("watiam")
    @watiamList.each do |x|
        if @user.watiam == x.watiam
            @userCannotBeCreated = true
        end
    end
    if @userCannotBeCreated == false
        if @user.save
          log_in @user
          redirect_to root_url, notice: 'Account created and logged in.'
        else
          render :new
        end
    else
        flash[:alert] = "That WATIAM has an account associated with it already."
        render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def check_path
        current_path = request.env['PATH_INFO']
        if current_path == "/users" || current_path == "/managers"
            redirect_to user_dashboard_path
        end
    end
    
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :flag, :watiam, :password, :first_name, :last_name, :password_confirmation)
    end 
end
