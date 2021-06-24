require "rails_helper"

describe CartsController do
  let!(:products) {create_list(:product, 15)}
  let!(:user) {create(:user)}
  let!(:product) {products.first}
  before (:each) do
    sign_in user
    session[:cart] = {product.id.to_s => 10}
  end

  describe "GET#show" do
    it "show the current cart" do
      get :show
      expect(response).to render_template :show
    end

    it "calculate the totals of total of products" do
      get :show
      expect(assigns(:totals)).not_to be nil
    end

    it "auto delete the products in cart if product is not available in database anymore" do
      session[:cart] = {"0" => 10}
      get :show
      expect(assigns(:products).ids).not_to include(0)
    end
  end

  describe "POST#create" do
    it "add the product to the cart" do
      new_product = create(:product)
      post :create, params: {id: new_product.id}
      expect(session[:cart].keys).to include(new_product.id.to_s)
    end

    it "increase product already in cart to 1" do
      quantity = session[:cart][product.id.to_s]
      post :create, params: {id: product.id}
      expect(session[:cart][product.id.to_s]).to eq(quantity + 1)
    end

    it "return to products path and flash if product id is not valid" do
      post :create, params: {id: 0}
      expect(response).to redirect_to products_path
    end
  end

  describe "DELETE#remove" do
    it "remove the product from cart" do
      delete :remove, params: {id: product.id}
      expect(session[:cart].keys).not_to include(product.id.to_s)
    end
  end

  describe "DELETE#destroy" do
    it "clear all of products in cart" do
      delete :destroy
      expect(session[:cart]).to eq({})
    end

    it "flash if nothing to clear" do
      session[:cart] = {}
      delete :destroy
      expect(flash[:danger]).to eq I18n.t("cart.empty")
    end
  end

  describe "POST#create" do
    it "increase quantity of cart item to 1" do
      quantity = session[:cart][product.id.to_s]
      post :increase, params: {id: product.id}
      expect(session[:cart][product.id.to_s]).to eq(quantity + 1)
    end

    it "flash if the quantity is more than the stock" do
      session[:cart] = {product.id.to_s => product.quantity}
      post :increase, params: {id: product.id}
      expect(flash[:danger]).to eq I18n.t("cart.over")
    end
  end

  describe "POST#descrease" do
    it "descrease quantity of cart item to 1" do
      quantity = session[:cart][product.id.to_s]
      post :descrease, params: {id: product.id}
      expect(session[:cart][product.id.to_s]).to eq(quantity - 1)
    end

    it "remove item from cart if quanity in cart is 1" do
      session[:cart] = {product.id.to_s => 1}
      post :descrease, params: {id: product.id}
      expect(session[:cart].keys).not_to include(product.id.to_s)
    end
  end

  describe "POST#update" do
    it "update the quantity if cart item with new number" do
      post :update, params: {
        session: {
          quantity: 10
        },
        id: product.id
      }
      expect(session[:cart][product.id.to_s]).to eq 10
    end

    it "update the quantity if cart item with if the number larger than stock" do
      quantity = product.quantity + 1
      post :update, params: {
        session: {
          quantity: quantity
        },
        id: product.id
      }
      expect(flash[:danger]).to eq I18n.t("cart.over")
    end
  end

end
