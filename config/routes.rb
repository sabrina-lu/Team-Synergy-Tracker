Rails.application.routes.draw do
  resources :surveys
  resources :users
  resources :managers
  resources :teams
  resources :responses
  
  get 'dashboard', to: 'users#dashboard', as: 'user_dashboard'
  #get 'users/:id/dashboard', to: 'users#dashboard', as: 'user_dashboard'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
