class FoodsController < ApplicationController
  before_action :load_food, only: :show
  before_action :categories_select_id_name, only: %i(index)
  authorize_resource

  def index
    @foods = Food.search_by_name(params[:name])
                 .filter_category(params[:category_id]).enabled.recent_foods
                 .page(params[:page])
                 .per(Settings.per_page_food)
    render "static_pages/shop"
  end

  def show; end

  private

  def load_food
    @food = Food.find_by(id: params[:id])
    return if @food

    flash[:danger] = t "show_food_fail"
    redirect_to root_url
  end
end
