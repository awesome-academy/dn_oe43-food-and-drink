module OrdersHelper
  def status_for_cancel order
    order.waiting? || order.delivering?
  end

  def check_authorize order
    order.user == current_user || current_user.admin?
  end
end
