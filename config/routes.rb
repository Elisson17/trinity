Rails.application.routes.draw do
  devise_for :users
  mount MissionControl::Jobs::Engine, at: "/admin/jobs_queue"

  get "whatsapp_verification", to: "whatsapp_verifications#show"
  post "whatsapp_verification", to: "whatsapp_verifications#create"
  get "whatsapp_verification/resend", to: "whatsapp_verifications#resend", as: :resend_whatsapp_verification
  post "whatsapp_verification/resend", to: "whatsapp_verifications#resend"

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

    get "cart", to: "cart#show", as: :cart
    post "cart/add_item", to: "cart#add_item", as: :cart_add_item
    patch "cart/update_item", to: "cart#update_item", as: :cart_update_item
    delete "cart/remove_item", to: "cart#remove_item", as: :cart_remove_item
    delete "cart/clear", to: "cart#clear", as: :cart_clear

    namespace :user do
      root "settings#profile", as: :settings_root
      get "profile", to: "settings#profile"
      get "orders", to: "settings#orders"
      get "favorites", to: "settings#favorites"
      get "addresses", to: "settings#addresses"
      patch "profile", to: "settings#update_profile"
      post "addresses", to: "settings#create_address"
      patch "addresses/:id", to: "settings#update_address", as: :update_address
      delete "addresses/:id", to: "settings#destroy_address", as: :destroy_address
    end
  end

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
