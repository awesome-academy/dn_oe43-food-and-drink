class Admin::OrdersController < AdminController
  before_action :load_order, only: :next_status
  authorize_resource

  include Admin::OrdersHelper
  def index
    @orders = Order.latest.paginate(page: params[:page])
    authorize! :index, @orders
  end

  def next_status
    if status_for_next @order
      case @order.status
      when "waiting"
        @order.approved!
      when "approved"
        @order.delivering!
      when "delivering"
        @order.delivered!
      end
      flash[:success] = t "order.next_success"
      redirect_to @order
    else
      flash[:danger] = t "order.wrong_status"
      redirect_to admin_orders_path
    end
  rescue StandardError
    flash[:danger] = t "index.error"
    redirect_to admin_orders_path
  end

  private

  def load_order
    @order = Order.find_by id: params[:order_id]
    return if @order

    flash[:danger] = t "order.nil"
    redirect_to admin_orders_path
  end
end
