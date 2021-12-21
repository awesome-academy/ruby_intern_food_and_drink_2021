class CartsController < ApplicationController
  before_action :load_food, only: :create

  def index
    load_cart
  end

  def create
    @food_id = params[:food_id].to_i
    @quantity = params[:quantity].to_i
    if @quantity.positive?
      if food_in_cart?
        @quantity = session[:cart][@food_id.to_s] + @quantity
        check_quantity
      end
    else
      @quantity = 1
    end
    session[:cart][@food_id.to_s] = @quantity
    load_cart
  end

  def update
    @food_id = params[:food_id].to_i
    @quantity = params[:quantity].to_i
    session[:cart][@food_id.to_s] = @quantity
    load_cart
  end

  def destroy
    food_id = params[:id].to_i
    session[:cart].delete(food_id.to_s)
    load_cart
  end

  private

  def load_food
    @food = Food.find_by id: params[:food_id]
    return if @food

    flash[:danger] = t "show_food_fail"
    redirect_to root_path
  end

  def load_cart
    qtity = session[:cart]
    @carts = Food.find_foods_cart(qtity.keys)
    @total = total_money @carts
  end

  def food_in_cart?
    session[:cart].key?(@food_id.to_s)
  end

  def check_quantity
    return unless @quantity > @food.quantity

    @quantity = @food.quantity
  end

  def total_money arr
    arr.reduce(0) do |sum, item|
      sum + session[:cart][item.id.to_s] * item.price
    end
  end
end
