Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :vendors  
  resources :parts
  resources :orders
  resources :inventories

  get 'dashboard', to: 'dashboard#index'
  root to: 'dashboard#index'
end