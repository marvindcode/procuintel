Rails.application.routes.draw do
  root "dashboard#index"
  get "/dashboard", to: "dashboard#index"

  devise_for :users

  get    "/login",  to: redirect("/users/sign_in")
  delete "/logout", to: "devise/sessions#destroy"

  resources :vendors
  resources :warehouses
  resources :parts do
    resources :inventories, shallow: true
    resources :demand_forecasts, only: [:index]
  end
  resources :inventories, only: [:index, :show]
  resources :demand_forecasts, only: [:index]
end

  

    



