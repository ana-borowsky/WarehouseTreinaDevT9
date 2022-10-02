Rails.application.routes.draw do
  devise_for :users
  root to: 'warehouses#index'
  resources :warehouses, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :product_models, only: [:index, :new, :create, :show]

  resources :orders, only: [:show, :new, :create] do
    get 'search', on: :collection 
  end
end
