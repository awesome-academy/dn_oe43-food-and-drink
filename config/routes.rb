Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "static_pages/home"
    get "static_pages/help"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    post "carts/create/:id", to: "carts#create", as: "add_to_cart"
    get "carts/show", as: "cart"
    post "carts/increase/:id", to: "carts#increase", as: "increase"
    post "carts/descrease/:id", to: "carts#descrease", as: "descrease"
    post "carts/remove/:id", to: "carts#remove", as: "remove_cart_item"
    delete "clear_cart", to: "carts#destroy"
    resources :categories, only: [:show, :index]
    resources :products, only: [:show, :index]
  end
end
