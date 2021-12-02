class Admin::FoodsController < Admin::AdminsController
  def index
    @foods = Food.recent_foods.page(params[:page]).per(Settings.per_page)
  end

  def new
    @food = Food.new
    @food.build_category
  end

  def create
    @food = Food.new food_params
    if @food.save
      flash[:success] = t "add_success"
      redirect_to admin_food_path(@food)
    else
      flash.now[:danger] = t "add_fail"
      render :new
    end
  end

  def show
    @food = Food.find_by id: params[:id]
    return if @food

    flash[:danger] = t "show_food_fail"
    redirect_to admin_foods_path
  end

  private

  def food_params
    params.require(:food)
          .permit(Food::ATTR_CHANGE, images: [],
                  category_attributes: [:category_name])
  end
end
