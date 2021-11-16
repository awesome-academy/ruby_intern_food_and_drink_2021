class Admin::CategoriesController < Admin::AdminsController
  def index
    @categories = Category.all.page(params[:page]).per(Settings.per_page)
  end

  def new
    @category = Category.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "add_success"
    else
      flash[:danger] = t "add_fail"
    end
    redirect_to admin_categories_path
  end

  def destroy
    @category = Category.find_by id: params[:id]
    if @category&.destroy
      flash[:success] = t "category_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to admin_categories_path
  end
  private
  def category_params
    params.require(:category).permit Category::ATTR_CHANGE
  end
end
