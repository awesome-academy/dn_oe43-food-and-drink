class StaticPagesController < ApplicationController
  def home
    params[:q] ||= {}
    @q = if params[:q][:category_id]
           Product.ransack(params[:q][:category_id])
         else
           Product.ransack(params[:q])
         end
    @catgories = Category.select(:id, :name)
    @products = @q.result.paginate(page: params[:page])
    render "products/index"
  end

  def help; end
end
