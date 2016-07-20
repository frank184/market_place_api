Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create], controller: 'v1/users'
    end
  end
end
