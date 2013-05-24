SmartHome::Application.routes.draw do

  get "session/new"

  get "session/create"

  get "session/destroy"

  get '/login' => 'sessions#new'

  resources :users

  root :to => 'sessions#new'
end
