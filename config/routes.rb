Rails.application.routes.draw do
  resources :messages
  resources :applications, param: :token do
    resources :chats, param: :num do
      resources :messages, param: :msg_no do
        collection do
          post 'search/', to: 'messages#search'
        end
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
