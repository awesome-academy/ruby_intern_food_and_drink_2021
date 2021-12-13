Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
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
    get :login, to: "sessions#new"
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    resources :users do
      resources :orders, only: %i(index show) do
        put :cancel, on: :member
      end
    end
    resources :foods, only: :show
    resources :carts
  end
end
