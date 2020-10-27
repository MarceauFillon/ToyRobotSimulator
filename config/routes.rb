Rails.application.routes.draw do
  get 'robots/index'
  post 'robots/place'

  resources :robots
  
  root 'robots#index'
end
