Rails.application.routes.draw do
  resources :teams
  resources :managers
  resources :responses
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
