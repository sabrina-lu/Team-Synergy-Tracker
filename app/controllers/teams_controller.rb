class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/1
  def show
    @users = Team.find(params[:id]).users
  end

  # GET /teams/new
  def new
    @new = true
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @team = Team.new
  end
    
   # GET /teams/1/edit
  def edit
    @edit = true
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @users = Team.find(params[:id]).users
  end 
    
  # GET /teams/1/members
  def edit_members
    @all_users = true
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @users = User.all
    @team = Team.find(params[:id])
  end
    
  # POST /teams/1/members/add
  def add_member
    @user = User.find(params[:user_id])
    team = Team.find_by(:id => params[:id])
    team.users << @user
    if team.save
        flash[:notice] = "Successfully added #{@user.first_name} to #{team.name}"
        s = Survey.create(user: @user, team: team, date: CURRENT_SURVEY_DUE_DATE)# creating a new survey when a member is added to a team
        s.save
        redirect_to edit_members_url(team)
    end
  end
    
  # POST /teams/1/members/delete
  def remove_member
    @user = User.find(params[:user_id])
    team = Team.find_by(:id => params[:id])
    team.users.delete(@user)
    if team.save
        flash[:notice] = "Successfully removed #{@user.first_name} from #{team.name}" 
        # https://stackoverflow.com/questions/11829850/find-by-multiple-conditions-in-rails
        s = Survey.find_by(user: @user, team: team) # deleting a survey when a member is deleted from a team
        #s.responses.destroy
        s.destroy
        redirect_to edit_members_url(team)
    end
  end

  # POST /teams
  def create
    @team = Team.new(team_params) 
    if @team.save
      @team.managers << current_user
      redirect_to edit_members_url(@team), notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to team_health_path(@team), notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to manager_dashboard_path, notice: 'Team was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name)
    end
end
