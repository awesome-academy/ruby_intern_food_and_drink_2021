class Admin::UsersController < Admin::AdminsController
  before_action :load_user, except: :index
  def index
    @users = User.all.page(params[:page]).per(Settings.per_page)
  end

  def update
    @user.update! activated: true
    flash[:success] = t "update_success"
    redirect_to admin_users_path
  end

  def destroy
    @user.update! activated: false
    flash[:success] = t "update_success"
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "no_user"
    redirect_to admin_users_path
  end
end
