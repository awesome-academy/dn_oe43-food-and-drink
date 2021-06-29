class ProductsController < ApplicationController
  before_action :init_q, only: :index
  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.nil"
    redirect_to products_path
  end

  def index
    @q = if params[:q][:category_id]
           Product.ransack(params[:q][:category_id])
         else
           Product.ransack(params[:q])
         end
    @catgories = Category.select(:id, :name)
    @products = @q.result.paginate(page: params[:page])
  end

  private

  def init_q
    params[:q] ||= {}
  end
end
