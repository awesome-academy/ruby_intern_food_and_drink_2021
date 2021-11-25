class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order, :load_carts, only: %i(show cancel)
  def index
    @orders = current_user.all_orders
                          .page(params[:page])
                          .per(Settings.page_per_medium)
  end

  def show; end

  def cancel
    if @order.open?
      @order.cancelled!
      send_mail
    else
      flash[:danger] = t "update_fail"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "update_fail"
  else
    flash[:success] = t "order_changed"
  ensure
    redirect_back(fallback_location: user_order_path)
  end

  private

  def load_order
    @order = current_user.orders.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "no_order"
    redirect_to root_path
  end

  def load_carts
    @carts = @order.carts.includes(:food)
    @total = total_order @carts
  end

  def total_order carts
    carts.reduce(0) do |total, cart|
      total + cart.quantity * cart.food_price
    end
  end

  def send_mail
    UserMailer.order_status(@order, @carts, @total).deliver_now
  end
end
