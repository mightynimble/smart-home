SmartHome::Application.routes.draw do

  get "temperatures/index"

  get "dashboards/index"

  get 'sessions/login' => 'sessions#new', :as => 'login'
  post 'sessions/login' => 'sessions#create'

  get 'sessions/logout' => 'sessions#destroy', :as => 'logout'
  get '/logout' => 'sessions#destroy', :as => 'logout'

  resources :users
  resources :sessions

  root :to => 'sessions#new'
end
