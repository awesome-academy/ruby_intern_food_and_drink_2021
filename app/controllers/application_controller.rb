class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  before_action :initializ_session
  before_action :load_cart

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def initializ_session
    session[:cart] ||= {}
  end

  def load_cart
    qtity = session[:cart]
    @carts = Food.find_foods_cart(qtity.keys)
  end
end
