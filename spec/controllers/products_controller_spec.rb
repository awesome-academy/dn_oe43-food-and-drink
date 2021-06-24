require "rails_helper"

describe ProductsController, type: :controller do
  let!(:category) { create(:category_with_products) }
  let!(:products) { category.products }
  let!(:product)  {products.first}

  describe "GET#index" do
    it "populates an arrays of all products" do
      get :index
      expect(assigns(:products)).to match_array products
    end

    it "populates an arrays of searched products" do
      products = Product.search("chicken")
      get :index, params: {q:"chicKen"}
      expect(assigns(:products)).to match_array products
    end

    it "populates an array of products for selected category" do
      products = Product.filters(category.id)
      get :index, params: {
        product: {
          category_id: category.id
        }
      }
      expect(assigns(:products)).to match_array products
    end

    it "populates an arrays of products with price order desc" do
      products = Product.desc_price
      get :index, params: {s: "desc"}
      expect(assigns(:products).to_a).to eq products
    end

    it "populates an arrays of products with price order asc" do
      products = Product.asc_price
      get :index, params: {s: "asc"}
      expect(assigns(:products).to_a).to eq products
    end
  end

  describe "GET#show" do
    it "return a product details if id is valid" do
      get :show, params: {id: products.first.id}
      expect(assigns(:product)).to eq product
    end

    it "return products list and flash if id is nil" do
      get :show, params: {id: 0}
      expect(flash[:danger]).to eq I18n.t("product.nil")
      expect(response).to redirect_to products_path
    end
  end
end
