Rails.application.routes.draw do
  get 'robots/index'
  post 'robots/place'
  post 'robots/move'
  post 'robots/rotate'

  resources :robots
  
  root 'robots#index'
end
