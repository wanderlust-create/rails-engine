# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
      end
    end
  end
end
