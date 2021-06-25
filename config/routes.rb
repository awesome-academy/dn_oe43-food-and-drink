Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "static_pages/home"
    get "static_pages/help"
    resources :carts do
      collection do
        post "create/:id", to: "carts#create", as: "add_to"
        post "increase/:id", to: "carts#increase", as: "increase"
        post "descrease/:id", to: "carts#descrease", as: "descrease"
        post "remove/:id", to: "carts#remove", as: "remove_item_from"
        post "update/:id", to: "carts#update", as: "update"
        get :show
        delete :destroy, as: "clear"
      end
    end
    resources :orders, except: [:update, :edit, :destroy] do
        collection do
            post "cancel/:id", to: "orders#cancel", as: "cancel"
        end
    end
    resources :categories, only: [:show, :index]
    resources :products, only: [:show, :index]
    namespace :admin do
        resources :orders, only: :index do
            post "next_status", to: "orders#next_status"
        end
    end
    devise_for :users
  end
end
