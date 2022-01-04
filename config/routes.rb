Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
      resources :users
      resources :foods
      resources :categories
      resources :orders do
        member do
          put :approve
          put :reject
        end
      end
    end

    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/shop", to: "foods#index"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/checkout", to: "static_pages#checkout"
    get "/single", to: "static_pages#single"
    devise_for :users
    as :user do
      get "login" => "devise/sessions#new"
      get "signup", to: "devise/registrations#new"
      delete "logout" => "devise/sessions#destroy"
    end
    resources :users do
      resources :orders
    end
    resources :foods, only: :show
    resources :carts
    resources :orders, only: %i(new create)
  end
end
