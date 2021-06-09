Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "static_pages/home"
    get "static_pages/help"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
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
    resources :orders, only: [:new, :create, :show, :index]
    resources :categories, only: [:show, :index]
    resources :products, only: [:show, :index]
  end
end
