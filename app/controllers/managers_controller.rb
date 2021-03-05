class ManagersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_manager, only: [:show, :edit, :update, :destroy] # this was og the other two were randomly added to match user and havent been tested yet ¯\_(ツ)_/¯
  before_action :authorized_to_modify_and_destroy, only: [:edit, :update, :destroy]

  # GET /managers
  def index
    @managers = Manager.all
  end

  # GET /managers/1
  def show
  end

  # GET /managers/new
  def new
    manager_params = params
    @manager = Manager.new
    if manager_params[:flag] == "Manager"
      @manager = Manager.create
    end
  end

  # GET /managers/1/edit
  def edit
  end
    
  # GET /manager_dashboard
  def dashboard
    @manager = current_user_is_manager
    if !@manager
        redirect_to_manager_login
    elsif
      q1 = "How do you feel about this week in comparison to last week?"
      q2 = "How did you feel about this week?"
      q3 = "How would you rate your communication with your team members this week?"
      q4 = "How do you feel about the workload you had this week?"
      @questions = [q1,q2,q3,q4]
    
      @CURRENT_SURVEY_DUE_DATE = CURRENT_SURVEY_DUE_DATE  
      @next_week_survey_generated = true
      @manager.teams.each do |team|
        if team.users.first and !team.users.first.surveys.find_by(team_id: team.id, date: NEXT_SURVEY_DUE_DATE)
          @next_week_survey_generated = false
        end      
      end
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
    @users = @team.users
    @surveysToCalc = Survey.select("id").where(:user_id => @users.ids, :team_id => @team).to_a
    @responseValues = Response.select("answer").where(:survey_id => @surveysToCalc).to_a;    #calculate health for the team
    @health_value = 0
    @responseValues.each { |x|
        @health_value = @health_value + x.answer.to_f / 5
    }
    if @responseValues.size > 0
        @health_value = (@health_value * 100 /@responseValues.size).to_i; 
    end
  end

  # POST /managers
  def create    
    if manager_params[:flag] == "Manager"
      @manager = Manager.new(manager_params)
    else
      # Source (https://stackoverflow.com/questions/9661611/rails-redirect-to-with-params) used for learning how to pass parameter values with a redirect
      redirect_to new_user_url(:name => manager_params[:name], 
                               :user_id => manager_params[:manager_id],
                               :flag => manager_params[:flag],
                               :watiam => manager_params[:watiam],
                               :password => manager_params[:password],
                               :first_name => manager_params[:first_name],
                               :last_name => manager_params[:last_name],
                               :password_confirmation => manager_params[:password_confirmation]) and return
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
    end
  end

  # PATCH/PUT /managers/1
  def update
    if @manager.update(manager_params)
      redirect_to @manager, notice: 'Manager was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /managers/1
  def destroy
    @manager.destroy
    redirect_to managers_url, notice: 'Manager was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manager_params
      params.require(:manager).permit(:name, :manager_id, :flag, :watiam, :password, :first_name, :last_name, :password_confirmation)
    end
end
