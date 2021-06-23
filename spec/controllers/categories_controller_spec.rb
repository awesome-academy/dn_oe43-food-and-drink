require "rails_helper"

describe CategoriesController do
  let!(:categories) {create_list(:category_with_products, 5)}
  let!(:category) {categories.first}
  let!(:products) {category.products}

  describe "GET#index" do
    it "populates all categories" do
      get :index
      expect(assigns(:categories)).to match_array categories
    end
  end

  describe "GET#show" do
    it "populates all products of the categories" do
      get :show, params: {id: category.id}
      expect(assigns(:products)).to match_array products
    end

    it "redirect to categories path and flash if id is invalid" do
      get :show, params: {id: 0}
      expect(response).to redirect_to categories_path
      expect(flash[:danger]).to eq I18n.t("category.nil")
    end
  end
end
