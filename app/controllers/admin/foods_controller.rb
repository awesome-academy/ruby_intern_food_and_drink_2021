class Admin::FoodsController < Admin::AdminsController
  def index
    @foods = Food.recent_foods.page(params[:page]).per(Settings.per_page)
  end

  def show
    @food = Food.find_by id: params[:id]
    return if @food

    flash[:danger] = t "show_product_fail"
    redirect_to admin_foods_path
  end
end
