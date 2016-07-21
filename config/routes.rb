Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy], controller: 'v1/users'
      resources :sessions, only: [:create, :destroy], controller: 'v1/sessions'
      resources :products, only: [:show, :index], controller: 'v1/products'
    end
  end
end
