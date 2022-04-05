# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get 'most_items', to: 'merchants#most_items'
      end
      get '/items/find', to: 'items#find_by'
      get '/merchants/find_all', to: 'merchants#find_all'
      resources :items, only: %i[index show create update destroy]
      resources :merchants, only: %i[index show] do
        resources :items, controller: 'merchant_items', only: %i[index]
      end
      namespace :revenue do
        resources :merchants, only: %i[index]
      end


      get '/items/:id/merchant', to: 'item_merchant#index'
    end
  end
end
