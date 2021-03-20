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
      q1 = "How do you feel about this week in comparison to last week?"
      q2 = "How did you feel about this week?"
      q3 = "How would you rate your communication with your team members this week?"
      q4 = "How do you feel about the workload you had this week?"
      @questions = [q1,q2,q3,q4]
      @CURRENT_SURVEY_DUE_DATE = CURRENT_SURVEY_DUE_DATE
    end 
  end
  
  # GET /team_health/1/metrics
  def team_health
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @team = Team.find(params[:id])
    if !current_user_is_on_team(@team)
        redirect_to manager_dashboard_path, notice: 'You do not have permission to view this team.'
    end
    @team_health = true
    @team_users = @team.users
    @users = User.get_ordered_survey_indicator(@team, CURRENT_SURVEY_DUE_DATE)    
    @health_value = @team.get_total_team_health(0, CURRENT_SURVEY_DUE_DATE)
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
    if current_user_is_manager
      @myTeams = Manager.joins(:teams).select("team_id").where(:id => current_user.id) # get teams associated with this manager
      @myTeamMembers = Team.joins(:users).select("id").where(:id => @myTeams) # get users associated with this manager's teams
        @myTeamMembers.each do |ticket|
          @teamMemberIds = ticket.user_ids
        end
      @tickets = Ticket.where(:creator_id => @teamMemberIds)  #get tickets created by users associated with this manager's teams
      #@tickets = @myTeamMembers
    else
      redirect_to user_tickets_path 
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
