require "rails_helper"

describe Admin::OrdersController, type: :controller do
  let!(:user) { create(:user_with_orders, role: 0)}
  let!(:admin) { create(:user_with_orders, role: 1)}
  let!(:orders) {user.orders}
  let!(:order) {orders.first}

  before (:each) do
    sign_in admin
  end

  describe "GET#index" do
    it "populates all orders latest sorted in system" do
      orders = Order.latest
      get :index
      expect(assigns(:orders).to_a).to eq orders
    end

    it "redirect to root path and flash if user is not admin" do
      sign_in user
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "POST#next_status" do
    it "flash wrong status if order's status is invalid" do
      order = Order.canceled.first
      post :next_status, params: {order_id: order.id}
      expect(flash[:danger]).to eq I18n.t("order.wrong_status")
    end

    it "flash order nil if order id is invalid" do
      post :next_status, params: {order_id: 0}
      expect(flash[:danger]).to eq I18n.t("order.nil")
    end

    it "make order to the next status" do
      order.waiting!
      post :next_status, params: {order_id: order.id}
      expect(assigns(:order).status).to eq("approved")

      post :next_status, params: {order_id: order.id}
      expect(assigns(:order).status).to eq("delivering")

      post :next_status, params: {order_id: order.id}
      expect(assigns(:order).status).to eq("delivered")
    end
  end
end
