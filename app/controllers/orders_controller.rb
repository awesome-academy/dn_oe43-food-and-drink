class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :check_cart, :load_products,
                :handle_total, only: [:new, :create]
  before_action :load_order, only: [:show, :cancel]
  before_action :check_cancel_status, only: :cancel

  include OrdersHelper
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

  def show; end

  def index
    @orders = current_user.orders.latest
    if params[:status].present?
      @orders = @orders.group_by_status(params[:status])
    end
    @orders = @orders.paginate(page: params[:page])
  end

  def cancel
    handle_cancel
    if flash[:success]
      redirect_to @order
    else
      render :new
    end
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

  def handle_cancel
    ActiveRecord::Base.transaction do
      @order.cancel_order
      flash[:success] = t "order.cancel_success"
    rescue StandardError
      flash[:danger] = t "index.error"
      raise ActiveRecord::Rollback
    end
  end

  def check_cart
    return unless session[:cart] == {} || session[:cart].nil?

    flash[:danger] = t "cart.nothing"
    redirect_to root_path
  end

  def handle_total
    @totals = @products.reduce(0) do |sum, p|
      sum + session[:cart][p.id.to_s] * p.price
    end
  end

  def load_order
    authorize! :manage, @order
    return if @order

    flash[:danger] = t "order.nil"
    redirect_to root_path
  end

  def check_cancel_status
    return if status_for_cancel @order

    flash[:danger] = t "order.wrong_status"
    redirect_to @order
  end

  def check_order_owner
    return if check_authorize @order

    flash[:danger] = "t.not_order_owner"
    redirect_to root_path
  end
end
