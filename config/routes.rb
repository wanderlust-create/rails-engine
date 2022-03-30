# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, controller: 'merchant_items', only: %i[index]
      end
    end
  end

  resources :items, only: %i[index show]
end
