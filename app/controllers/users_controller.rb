class UsersController < ApplicationController
  layout "sign_up"

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      remember @user
      flash[:success] = t("sign_up.message_sign_up_success")
      redirect_to root_url
    else
      flash.now[:danger] = t("sign_up.message_sign_up_fail")
      render :new
    end
  end
  private
  def user_params
    params.require(:user).permit User::ATTR_CHANGE
  end
end
