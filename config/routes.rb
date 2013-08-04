SmartHome::Application.routes.draw do

  get "/system_metrics/total_processes" => 'system_metrics#total_processes'

  get "temperatures/index"

  get "temperatures/get_metrics" => 'temperatures#get_metrics'

  get "dashboards/index"

  get 'sessions/login' => 'sessions#new', :as => 'login'
  post 'sessions/login' => 'sessions#create'

  get 'sessions/logout' => 'sessions#destroy', :as => 'logout'
  get '/logout' => 'sessions#destroy', :as => 'logout'

  resources :users
  resources :sessions

  root :to => 'sessions#new'
end
