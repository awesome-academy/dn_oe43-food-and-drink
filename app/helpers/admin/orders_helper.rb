module Admin::OrdersHelper
  def status_for_next order
    !(order.canceled? || order.delivered?)
  end
end
