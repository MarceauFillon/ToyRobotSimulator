Rails.application.routes.draw do
  get 'robots/index'
  post 'robots/place'
  post 'robots/move'
  post 'robots/rotate'
  post 'robots/report'

  resources :robots
  
  root 'robots#index'
end
