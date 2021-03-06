Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  resources :surveys, except: [:index, :show, :edit, :new]
  resources :managers, except: [:index, :show, :edit]
  resources :teams, except: [:index, :show]
  resources :responses, except: [:index, :show, :edit, :new]
  resources :users, except: [:new, :index, :show, :edit]  
  resources :tickets, except: [:index]
    
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
  
  get 'my_tickets', to: 'users#tickets', as: 'user_tickets'
  get 'manager_tickets', to: 'managers#tickets', as: 'manager_tickets'
  #For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
