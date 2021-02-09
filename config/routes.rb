Rails.application.routes.draw do
  resources :surveys
  resources :users
  resources :managers
  resources :teams
  resources :responses
  
  get 'dashboard', to: 'users#dashboard', as: 'user_dashboard'
    
  get 'teams/:id/members', to: 'teams#add_members_page', as: 'add_members'
  post 'teams/:id/members/add', to: 'teams#add_member', as: 'confirm_add_member'
  post 'teams/:id/members/remove', to: 'teams#remove_member', as: 'confirm_remove_member'
  #For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
