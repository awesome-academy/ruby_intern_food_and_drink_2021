class FoodsController < ApplicationController
  before_action :load_food, only: :show

  def show; end

  private

  def load_food
    @food = Food.find_by(id: params[:id])
    return if @food

    flash[:danger] = t "show_food_fail"
    rediract_to root_url
  end
end
