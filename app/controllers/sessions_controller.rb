class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        if params[:session][:remember_me] == Settings.sessions.one
          remember user
        else
          forget user
        end
        redirect_back_or user
      else
        flash[:warning] = t "message"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "invalid_session"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
