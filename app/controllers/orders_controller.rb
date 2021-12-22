class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_order, :load_carts, only: %i(show update)
  def index
    @orders = current_user.all_orders
                          .page(params[:page])
                          .per(Settings.page_per_medium)
  end

  def new
    if session[:cart].blank?
      flash[:danger] = t "cart_empty"
      redirect_to root_path
    else
      qtity = session[:cart]
      @carts = Food.find_foods_cart(qtity.keys)
      @total = subtotal @carts
    end
  end

  def create
    ActiveRecord::Base.transaction do
      qtity = session[:cart]
      @carts = Food.find_foods_cart(qtity.keys)
      @total = subtotal @carts
      check_quantity_food @carts
      order = save_order
      order.save!
      save_carts order
      session.delete :cart
      flash[:success] = t "order_success"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "order_fail"
  ensure
    redirect_to user_orders_path(current_user)
  end

  def show; end

  def update
    if @order.open?
      @order.cancelled!
      @order.orders_user!
      update_quantity_food :+
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

  def subtotal arr
    arr.reduce(0) do |sum, item|
      sum + session[:cart][item.id.to_s] * item.price
    end
  end

  def save_order
    current_user.orders.build(
      phone: params[:phone],
      address: params[:address]
    )
  end

  def save_carts order
    qtity = session[:cart]
    qtity.each do |food_id, quantity|
      next if food_id.nil?

      food = Food.find_by(id: food_id)
      @cart = order.carts.build(
        quantity: quantity,
        food_id: food_id
      )
      @cart.save!
      remaining_quantity = food.quantity - quantity
      food.update!(quantity: remaining_quantity)
    end
  end

  # Update quantity when approved order
  def update_quantity_food operator
    @carts.each do |cart|
      food = cart.food
      food.quantity = food.quantity.send operator, cart.quantity
      food.save!
    end
  end

  # Check quantity food with quantity in cart
  def check_quantity_food carts
    food_in_cart = ""
    carts.each do |item|
      if session[:cart][item.id.to_s] > item.quantity
        food_in_cart << item.name << ", "
      end
    end
    return if food_in_cart.blank?

    flash[:danger] = t("quantity_not_enough") << food_in_cart
    redirect_to user_orders_path(current_user)
  end
end
