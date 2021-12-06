class StaticPagesController < ApplicationController
  include FoodsHelper

  def home
    @foods = Food.enabled.recent_foods.take(Settings.page_per_min)
  end

  def shop
    @foods = Food.enabled.recent_foods.page(params[:page])
                 .per(Settings.per_page_food)
  end

  def about; end

  def contact; end

  def cart; end

  def checkout; end
end
