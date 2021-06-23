class ProductsController < ApplicationController
  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.nil"
    redirect_to products_path
  end

  def index
    @products = Product.search(params[:q].downcase) if params[:q].present?
    @products ||= Product.all
    handle_select_category
    handle_sort
    @products = @products.paginate(page: params[:page])
  end

  private

  def handle_sort
    return unless params[:s]

    @products = if params[:s] == "asc"
                  @products.asc_price
                else
                  @products.desc_price
                end
  end

  def handle_select_category
    return unless params[:product] && params[:product][:category_id].present?

    @products = @products.filters(params[:product][:category_id])
    @category = Category.find_by id: params[:product][:category_id]
  end
end
