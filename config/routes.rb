Rails.application.routes.draw do
  resources :messages
  resources :comments
  resources :users

  root to: 'messages#index'

end
