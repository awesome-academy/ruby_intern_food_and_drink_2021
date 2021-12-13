class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, :load_carts,
                except: %i(index index_by_status)
  def index
    if params[:status].nil?
      @title = t "all"
      @orders = Order.includes(:carts, :user).recent_orders.page(params[:page])
                     .per(Settings.per_page)
    else
      load_orders params[:status]
    end
  end

  def show
    @title = t "order_detail"
  end

  def approve
    ActiveRecord::Base.transaction do
      if @order.open?
        check_quantity_food
        update_quantity_food :-
        @order.shipping!
        send_mail
        flash[:success] = t "approve_success"
      elsif @order.shipping?
        @order.completed!
        send_mail
        flash[:success] = t "approve_success"
      else
        flash[:danger] = t "approve_failed"
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "approve_failed"
  ensure
    redirect_back(fallback_location: root_path)
  end

  def reject
    ActiveRecord::Base.transaction do
      if !@order.cancelled? && !@order.completed?
        update_quantity_food :+ unless @order.open?
        @order.cancelled!
        send_mail
      else
        flash[:danger] = t "reject_failed"
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "reject_failed"
  ensure
    redirect_back(fallback_location: admin_orders_path)
  end

  private

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "no_order"
    redirect_to admin_orders_path
  end

  def load_orders status
    if Order.statuses.include?(status)
      @title = t "status_order.#{status}"
      @orders = Order.send(status)
                     .includes(:carts, :user)
                     .recent_orders.page(params[:page])
                     .per(Settings.per_page)
    else
      flash[:success] = t "error_path"
      redirect_to admin_orders_path
    end
  end

  def total_order carts
    carts.reduce(0) do |total, cart|
      total + cart.quantity * cart.food_price
    end
  end

  def load_carts
    @carts = @order.carts.includes(:food).page(params[:page])
                   .per(Settings.per_page)
    @total = total_order @carts
  end

  def send_mail
    UserMailer.order_status(@order, @carts, @total).deliver_now
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
  def check_quantity_food
    food_in_cart = ""
    @order.carts.each do |cart|
      if cart.quantity > cart.food.quantity
        food_in_cart << cart.food_name << ", "
      end
    end
    return if food_in_cart.blank?

    flash[:danger] = t("quantity_not_enough") << food_in_cart
    redirect_back(fallback_location: admin_orders_path)
  end
end
