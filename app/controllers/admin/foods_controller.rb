class Admin::FoodsController < Admin::AdminsController
  def index
    @foods = Food.recent_foods.page(params[:page]).per(Settings.per_page)
  end
end
