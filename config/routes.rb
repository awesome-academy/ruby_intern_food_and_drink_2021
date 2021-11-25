Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
      resources :foods
      resources :categories
      resources :orders
      get "order_status/:status", to: "orders#index_by_status", as: :status
    end

    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/shop", to: "foods#index"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/cart", to: "static_pages#cart"
    get "/checkout", to: "static_pages#checkout"
    get "/single", to: "static_pages#single"
    get :login, to: "sessions#new"
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    resources :users
    resources :foods, only: :show
  end
end
