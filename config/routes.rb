# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'items#find_by'
      get '/merchants/find_all', to: 'merchants#find_all'
      resources :items, only: %i[index show create update destroy] do
        resources :merchants, controller: 'items_merchant', only: %i[index]
      end
      resources :merchants, only: %i[index show] do
        resources :items, controller: 'merchant_items', only: %i[index]
      end
    end
  end
end
