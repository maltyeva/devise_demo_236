Rails.application.routes.draw do
  resources :restaurants do
    collection do
      get 'dashboard', to: "restaurants#dashboard"
    end
  end
  resources :flats
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
