require "rails_helper"

describe StaticPagesController do

  let!(:category) {create(:category_with_products)}
  let!(:products) {category.products}

  describe "GET#home" do
    it "populates all products" do
      get :home
      expect(assigns(:products)).to match_array products
    end
  end

  describe "GET#help" do
    it "render help template" do
      get :help
      expect(response).to render_template :help
    end
  end
end
