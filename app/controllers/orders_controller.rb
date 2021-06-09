class OrdersController < ApplicationController
  before_action :check_cart, :load_products,
                :handle_total, only: [:new, :create]
  def new
    @order = Order.new
  end

  def create
    handle_create
    if flash[:success]
      session[:cart] = {}
      redirect_to @order
    else
      render :new
    end
  end

  def show
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order.nil"
    redirect_to root_path
  end

  def index
    @orders = current_user.orders.latest.paginate(page: params[:page])
  end

  private

  def load_products
    @products = Product.load_cart(session[:cart].keys)
  end

  def order_params
    params.require(:order).permit(:name, :address, :phone)
  end

  def handle_create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build order_params
      @order.save!
      @order.add_order_items session[:cart], @totals
      flash[:success] = t "order.success"
    rescue StandardError
      flash[:danger] = t "index.error"
      raise ActiveRecord::Rollback
    end
  end

  def check_cart
    return unless session[:cart] == {}

    flash[:danger] = t "cart.nothing"
    redirect_to root_path
  end

  def handle_total
    @totals = @products.reduce(0) do |sum, p|
      sum + session[:cart][p.id.to_s] * p.price
    end
  end
end
