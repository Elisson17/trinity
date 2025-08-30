Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("/v1")
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :v1 do
    root "home#index"
    resources :products, only: [ :index, :show ]

    namespace :user do
      root "settings#profile", as: :settings_root
      get "profile", to: "settings#profile"
      get "orders", to: "settings#orders"
      get "favorites", to: "settings#favorites"
      get "addresses", to: "settings#addresses"
      patch "profile", to: "settings#update_profile"
      post "addresses", to: "settings#create_address"
      delete "addresses/:id", to: "settings#destroy_address", as: :destroy_address
    end
  end

  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :products do
      member do
        delete :remove_image
      end
    end
    get "dashboard", to: "dashboard#index"
  end
end
