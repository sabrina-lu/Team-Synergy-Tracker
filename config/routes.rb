Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  resources :surveys
  resources :users
  resources :managers
  resources :teams
  resources :responses
  resources :users, except: [:new]  
    
  get '/signup', to: 'users#new'
  get '/login',  to: 'sessions#new'    
  post '/login',  to: 'sessions#create'    
  get '/logout', to: 'sessions#destroy' 
    
  get 'dashboard', to: 'users#dashboard', as: 'user_dashboard'
  get 'dashboard/teams/:id', to: 'users#team_list', as: 'user_team_list'    
  get 'dashboard/teams/:id/weekly_surveys', to: 'users#weekly_surveys', as: 'weekly_surveys'
    
  get 'manager_dashboard', to: 'managers#dashboard', as: 'manager_dashboard'
  get 'team_health/:id/metrics', to: 'managers#team_health', as: 'team_health'

  get 'teams/:id/members', to: 'teams#edit_members', as: 'edit_members'
  post 'teams/:id/members/add', to: 'teams#add_member', as: 'confirm_add_member'
  post 'teams/:id/members/remove', to: 'teams#remove_member', as: 'confirm_remove_member'
  #For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
