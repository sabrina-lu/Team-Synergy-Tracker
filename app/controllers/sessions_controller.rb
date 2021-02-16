class SessionsController < ApplicationController
  # code from multi-users lab for MSCI 342 by Mark Smucker #
    def new
  end

  def create
    user = User.find_by(watiam: params[:watiam].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      get_dashboard
    else
      flash.now[:notice] = 'Cannot log you in. Invalid email or password.'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url, notice: 'Logged out.'
  end
end
