class Admin::AdminsController < ApplicationController
  before_action :authenticate_user!, :is_admin?
  layout "admin"

  def index; end

  private

  def is_admin?
    return if current_user.role?

    flash[:danger] = t "not_permission"
    redirect_to root_url
  end
end
