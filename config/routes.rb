Rails.application.routes.draw do
  root to: 'warehouses#index'
  resources :warehouses, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
