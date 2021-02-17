class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorized_to_modify_and_destroy, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
    
  # GET /dashboard
  def dashboard
     @user = current_user #get logged in user from session
     @teams = @user.teams
     @surveys = @user.surveys
     @completed = {}
     @teams.each do |team| #for each team user is on, check if user completed the survey for that team
         if @surveys.exists?(team_id: team.id)
             @completed[team] = true
         else 
             @completed[team] = false
         end
     end
  end
    
  # GET /dashboard/teams/1 
  def team_list
      @team = Team.find(params[:id])
      @users = @team.users
  end
    
  # Get /weekly_surveys/teams/1
  def weekly_surveys
    @team = Team.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user    
      redirect_to root_url, notice: 'Account created and logged in.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    if @user == current_user
        log_out
    end
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :watiam, :password, :first_name, :last_name,
                                :password_confirmation)
    end
    
   def authorized_to_modify_and_destroy
   if current_user != @user
      redirect_to users_url, notice: "You can only edit or delete your own account."
   end
end
end
