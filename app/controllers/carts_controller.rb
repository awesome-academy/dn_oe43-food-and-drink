class CartsController < ApplicationController
  before_action :must_login, :init_cart
  before_action :load_product, except: [:show, :destroy]
  before_action :handle_cart, only: :show
  before_action :check_quantity, only: :update
  before_action :empty_cart?, only: :destroy

  def create
    flash[:success] = t("cart.add_item", name: @product.name)
    handle_quantity
    redirect_to root_path
  end

  def show
    @products = Product.load_cart(session[:cart].keys)
                       .paginate(page: params[:page])
    @totals = @products.reduce(0) do |sum, p|
      sum + session[:cart][p.id.to_s] * p.price
    end
  end

  def remove
    delete_cart_item @product.id
    flash[:success] = t("cart.item_removed", name: @product.name)
    redirect_to cart_path
  end

  def destroy
    session[:cart] = {}
    flash[:success] = t "cart.cleared"
    redirect_to carts_path
  end

  def increase
    if session[:cart][@product.id.to_s] == @product.quantity
      flash.now[:danger] = t "cart.over"
    else
      session[:cart][@product.id.to_s] += 1
    end
    redirect_to cart_path
  end

  def descrease
    if session[:cart][@product.id.to_s] == 1
      delete_cart_item @product.id
    else
      session[:cart][@product.id.to_s] -= 1
    end
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  def update
    session[:cart][@product.id.to_s] = params[:session][:quantity].to_i
    respond_to do |format|
      format.html{redirect_to carts_path}
      format.js
    end
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.nil"
    redirect_to products_path
  end

  def handle_quantity
    if session[:cart].include? @product.id.to_s
      session[:cart][@product.id.to_s] += 1
    else
      session[:cart][@product.id.to_s] = 1
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

      delete_cart_item id
    end
  end

  def delete_cart_item id
    session[:cart].delete(id.to_s)
  end

  def empty_cart?
    return unless session[:cart] == {}

    flash[:danger] = t "cart.empty"
    redirect_to carts_path
  end

  def init_cart
    session[:cart] ||= {}
  end

  def check_quantity
    return if params[:session][:quantity].to_i < @product.quantity &&
              params[:session][:quantity].to_i.positive?

    session[:cart][@product.id.to_s] = 1
    flash[:danger] = t "cart.over"
    redirect_to carts_path
  end
end
