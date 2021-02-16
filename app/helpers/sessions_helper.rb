module SessionsHelper
    # code from multi-users lab for MSCI 342 by Mark Smucker #
  def log_in user
    session[:user_id] = user.id
    @current_user = nil
  end

  def logged_in?
     # You may have a session[:user_id], but if you don't
     # also have an entry in the database, we cannot say
     # you are logged in, for you don't exist!  This could
     # happen if an administrator deleted your account 
     # while logged_in.  
     !current_user.nil?
  end   
    
    # Code based on https://guides.rubyonrails.org/action_controller_overview.html#filters
  def require_login
    unless logged_in?
      flash[:notice] = "Please log in."
      redirect_to login_url 
    end
  end
    
  def current_user
     if !session[:user_id].nil?
        if @current_user.nil?
            # if id not in DB, find_by returns nil
            @current_user = User.find_by(id: session[:user_id])
        end
     else
        @current_user = nil
     end
     return @current_user 
  end
  
  # returns manager if current user is manager and nil otherwise
  def current_user_is_manager
    return Manager.find_by(:watiam => current_user.watiam)
  end
    
  def redirect_to_manager_login
      flash[:notice] = "Please login as a manager to view this site."
      redirect_to login_path
  end
    
  def get_dashboard
      if current_user_is_manager
          redirect_to manager_dashboard_path
      else
          redirect_to user_dashboard_path
      end
  end
    
  def log_out
      session.delete(:user_id)
      @current_user = nil
  end
end
