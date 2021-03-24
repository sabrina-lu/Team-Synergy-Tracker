class SessionsController < ApplicationController
  # code from multi-users lab for MSCI 342 by Mark Smucker #
    def new
  end

  def create
    user = User.find_by(watiam: params[:watiam].downcase)
    if !user
        user = Manager.find_by(watiam: params[:watiam].downcase)
    end
    if user && user.authenticate(params[:password])
      log_in user
      get_dashboard
    else
      flash.now[:notice] = 'Cannot log you in. Invalid Watiam or Password.'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path, notice: 'Logged out.'
  end
end
