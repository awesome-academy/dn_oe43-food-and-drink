require "rails_helper"
include SessionsHelper

describe SessionsController do

  let!(:user) { create(:user) }
  describe "GET#new" do
    it "render new template of login" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "DELETE#destroy" do
    before (:each) do
      log_in user
    end

    it "log out user and redirect to root path" do
      delete :destroy
      expect(session[:user_id]).to be nil
      expect(response).to redirect_to root_path
    end
  end

  describe "POST#create" do
    it "render login form agian and flash if login unsuccessfully" do
      post :create, params: {
        session: {
          email: "a@a.a"
        }
      }
      expect(response).to render_template :new
      expect(flash[:danger]).to eq I18n.t("index.wrong_login")
    end

    it "log in user and redirect to root path if login successfully" do
      post :create, params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
      expect(session[:user_id]).to eq user.id
      expect(response).to redirect_to root_path
    end
  end
end
