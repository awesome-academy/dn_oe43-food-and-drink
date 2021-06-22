require "rails_helper"
include SessionsHelper

describe OrdersController, type: :controller do
  let!(:user) { create(:user_with_orders) }
  let!(:orders)  { user.orders }
  let!(:order) { orders.first }

  before(:each) do
    log_in user
    init_cart
  end

  describe "GET#index" do
    before(:each) do
      get :index
    end

    it "populates an array of orders" do
     expect(assigns(:orders)).to match_array orders
    end

    it "populate an array of waiting orders" do
      get :index, params: {status: 0}
      expect(assigns(:orders)).to match_array orders.waiting
    end
  end

  describe "GET#new" do
    it "not return a new template of order if cart is empty" do
      get :new
      expect(response).not_to be_successful
    end

    it "return new template of order if cart is not empty" do
      session[:cart] = {Product.first.id.to_s => 11}
      get :new
      expect(response).to be_successful
      expect(response).to render_template :new
    end
  end

  describe "GET#show" do
    it "return a order's details" do
      get :show, params: {id: order.id}
      expect(assigns(:order)).to eq order
    end

    it "return root_path if order is nil" do
      get :show, params: {id: 0}
      expect(response).to redirect_to root_path
    end

    it "return root_path and flash not owner if other user" do
      other_user = create(:user)
      log_in other_user
      get :show, params: {id: order.id}
      expect(response).to redirect_to root_path
    end
  end

  describe "POST#create" do
    it "return new order if valid input" do
      session[:cart] = {Product.first.id.to_s => 11}
      post :create, params: {
        order: {
          name: order.name,
          address: order.address,
          phone: order.phone
        }
      }
      expect(flash[:success]).to eq(I18n.t("order.success"))
    end

    it "render new template again if invalid input" do
      session[:cart] = {Product.first.id.to_s => 11}
      post :create, params: {
        order: {
          name: order.name,
          address: order.address,
          phone: nil
        }
      }
      expect(flash[:danger]).to eq(I18n.t("index.error"))
      expect(response).to render_template :new
    end
  end

  describe "POST#cancel" do
    it "return a canceled order if status is valid" do
      order.waiting!
      post :cancel, params: { id: order.id}
      expect(flash[:success]).to eq(I18n.t("order.cancel_success"))
    end

    it "return flash danger if status is invalid" do
      order.canceled!
      post :cancel, params: { id: order.id}
      expect(flash[:danger]).to eq(I18n.t("order.wrong_status"))
    end

    it "return flash error if valid status but invalid quantity of items" do
      order.waiting!
      order.update! order_items: []
      post :cancel, params: { id: order.id}
      expect(flash[:danger]).to eq(I18n.t("index.error"))
    end
  end
end
