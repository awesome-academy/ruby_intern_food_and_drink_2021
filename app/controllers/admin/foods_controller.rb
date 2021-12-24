class Admin::FoodsController < Admin::AdminsController
  before_action :load_food, except: %i(index new create)

  def index
    @categories = Category.all
    @q = Food.ransack params[:q]
    @foods = @q.result.recent_foods.page(params[:page]).per(Settings.per_page)
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

  def show; end

  def edit; end

  def update
    if @food.update(food_params)
      flash[:success] = t "update_success"
      redirect_to admin_food_path(@food)
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    @carts = Cart.find_cart(@food.id)
    if @carts.present?
      check_status
    else
      @food.destroy
      flash[:success] = t "destroy_success"
    end
    redirect_to admin_foods_path
  end
  private

  def food_params
    params.require(:food)
          .permit(Food::ATTR_CHANGE, images: [],
                  category_attributes: [:category_name])
  end

  def load_food
    @food = Food.find_by id: params[:id]
    return if @food

    flash[:danger] = t "show_failer"
    redirect_to admin_foods_path
  end

  def check_status
    if @food.enabled?
      @food.disabled!
      flash[:success] = t "change_status"
    else
      flash[:danger] = t "no_delete"
    end
  end
end
