class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  before_action :initializ_session
  before_action :load_cart
  protect_from_forgery with: :exception
  before_action :permitted_parameters, if: :devise_controller?
  before_action :check_user?
  rescue_from CanCan::AccessDenied, with: :access_denied

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def initializ_session
    session[:cart] ||= {}
  end

  def load_cart
    qtity = session[:cart]
    @carts = Food.find_foods_cart(qtity.keys)
  end

  def categories_select_id_name
    @categories = Category.select(:id, :category_name)
  end

  def access_denied
    flash[:danger] = t "not_permission"
    redirect_to root_url
  end

  protected
  def check_user?
    return unless current_user

    return if current_user.activated?

    sign_out(current_user)
    flash[:danger] = "account_blocked"
    redirect_to login_path
  end

  def permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: User::USER_ATTRS
    devise_parameter_sanitizer.permit :account_update, keys: User::USER_ATTRS
  end
end
