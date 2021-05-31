class StaticPagesController < ApplicationController
  def home
    @products = Product.asc_name.paginate(page: params[:page])
  end

  def help; end
end
