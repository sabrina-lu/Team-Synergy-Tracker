class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorized_to_modify_and_destroy, only: [:edit, :update, :destroy]

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
         @user = current_user #get logged in user from session
         @teams = @user.teams
         @completed = {}
         @teams.each do |team| #for each team user is on, check if user completed the survey for that team             
             @survey = @user.surveys.where(team_id: team.id, date: CURRENT_SURVEY_DUE_DATE).last
             if @survey and @survey.responses.exists?
                 @completed[team] = true
             else 
                 @completed[team] = false
             end
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
              redirect_to user_dashboard_path, notice: 'You do not have permission to view this team.'
          end
          @users = @team.users
          @manager = @team.managers.first  #for now only one manager per team
      end
  end
    
  # GET /weekly_surveys/teams/1
  def weekly_surveys
    @team = Team.find(params[:id])
    if current_user_is_manager
         redirect_to manager_dashboard_path, notice: 'You do not have permission to respond to surveys.'
    elsif !current_user_is_on_team(@team)
         redirect_to user_dashboard_path, notice: 'You do not have permission to respond to another team\'s survey.'
    end
    @survey = Survey.find_by(user: current_user.id, team: @team.id, date: CURRENT_SURVEY_DUE_DATE)
    q1 = "How do you feel about this week in comparison to last week?"
    q2 = "How did you feel about this week?"
    q3 = "How would you rate your communication with your team members this week?"
    q4 = "How do you feel about the workload you had this week?"
    @questions = [q1,q2,q3,q4]
  end
    
  # GET /my_tickets
  def tickets
    if !current_user_is_manager
      @sentTickets = Ticket.where(creator_id: current_user.id)  #get tickets user created
      @receivedTickets = User.find(current_user.id).tickets  #get tickets about user
    else
      redirect_to manager_tickets_path
    end
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
        flash[:alert] = "That WATIAM has an account associated with it already"
        render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :user_id, :flag, :watiam, :password, :first_name, :last_name, :password_confirmation)
    end
    
   def authorized_to_modify_and_destroy
     if current_user != @user
      redirect_to users_url, notice: "You can only edit or delete your own account."
   end
  end   
end
