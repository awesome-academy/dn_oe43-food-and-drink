class CartsController < ApplicationController
  before_action :must_login, :check_product, only: :create
  before_action :handle_cart, only: :show

  def create
    flash[:success] = t("cart.add_item", name: @product.name)
    handle_quantity
    session[:cart] << @product.id
    redirect_to root_path
  end

  def show
    @products = Product.load_cart(session[:cart]).paginate(page: params[:page])
    @totals = @products.reduce(0) do |sum, p|
      sum + session["quantity#{p.id}"] * p.price
    end
  end

  def remove; end

  def destroy; end

  private

  def check_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.nil"
    redirect_to products_path
  end

  def handle_quantity
    if session["quantity#{@product.id}"].nil?
      session["quantity#{@product.id}"] = 1
    else
      session["quantity#{@product.id}"] += 1
    end
  end

  def must_login
    return if logged_in?

    flash[:danger] = t "cart.must_login"
    redirect_to login_path
  end

  def handle_cart
    session[:cart].each do |id|
      break if Product.find_by id: id

      session[:cart].delete id
      session.delete "quantity#{id}"
    end
  end
end
