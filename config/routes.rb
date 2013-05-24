SmartHome::Application.routes.draw do

  get "dashboards/index"

  post '/login' => 'sessions#create'
  post 'sessions/new' => 'sessions#create'

  resources :users
  resources :sessions

  root :to => 'sessions#new'
end
