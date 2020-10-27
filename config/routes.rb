Rails.application.routes.draw do
  get 'robots/index'
  post 'robots/place'
  post 'robots/move'

  resources :robots
  
  root 'robots#index'
end
