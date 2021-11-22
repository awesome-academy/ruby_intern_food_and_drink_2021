Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
    end

    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/shop", to: "static_pages#shop"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/cart", to: "static_pages#cart"
    get "/checkout", to: "static_pages#checkout"
    get "/single", to: "static_pages#single"
    resources :users
  end
end
