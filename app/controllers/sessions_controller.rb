class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        activated @user
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

  private

  def activated user
    log_in user
    if params[:session][:remember_me] == Settings.sessions.one
      remember user
    else
      forget user
    end
    redirect_back_or user
  end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t "notfound"
  end
end
