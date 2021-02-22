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
    end
  end
  
  # GET /team_health/1/metrics
  def team_health
    if !current_user_is_manager
      redirect_to_manager_login
    end
    @team = Team.find(params[:id])
    @users = @team.users
    @surveysToCalc = Survey.select("id").where(:user_id => @users.ids, :team_id => @team).to_a
    @responseValues = Response.select("answer").where(:survey_id => @surveysToCalc).to_a;    #calculate health for the team
    @health_value = 0
    @responseValues.each { |x|
        @health_value = @health_value + x.response.to_f / 5
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
      
    if @manager.save
      log_in @manager
      redirect_to root_url, notice: 'Account created and logged in.'
    else
      render :new
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
