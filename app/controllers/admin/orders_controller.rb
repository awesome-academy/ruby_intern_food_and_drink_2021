class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, only: :show

  def index
    @title = t "all"
    @orders = Order.includes(:carts, :user).recent_orders.page(params[:page])
                   .per(Settings.per_page)
  end

  def show
    @title = t "order_detail"
    @carts = @order.carts.includes(:food).page(params[:page])
                   .per(Settings.per_page)
    @total = total_order @carts
  end

  def index_by_status
    @title = t "status_order.#{params[:status]}"
    load_orders params[:status]
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
      @orders = Order.send(status)
                     .includes(:carts, :user)
                     .recent_orders.page(params[:page])
                     .per(Settings.per_page)
      render :index
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
end
