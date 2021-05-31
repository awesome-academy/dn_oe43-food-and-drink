class CategoriesController < ApplicationController
  before_action :load_category, only: :show

  def show
    @products = @category.products.asc_name.paginate(page: params[:page])
  end

  def index
    @categories = Category.asc_name.paginate(page: params[:page])
  end

  private

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "category.nil"
    redirect_to categories_path
  end
end
