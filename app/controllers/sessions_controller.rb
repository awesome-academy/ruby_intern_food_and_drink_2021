class SessionsController < ApplicationController
  layout "sign_up"
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activated? user
    else
      flash.now[:danger] = t "log_in.invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def check_activated? user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_to root_url
  end
end
