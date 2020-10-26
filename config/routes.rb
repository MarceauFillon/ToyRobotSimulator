Rails.application.routes.draw do
  get 'simulator/index'

  resources :robots
  
  root 'simulator#index'
end
