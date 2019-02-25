class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.sessions.one ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "invalid_session"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    log_out
    redirect_to root_path
  end
end
