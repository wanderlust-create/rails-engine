# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        if !Merchant.exists?(params[:merchant_id])
          render json: { error: 'Merchant does not exist' }, status: :not_found
        else
          render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
        end
      end
    end
  end
end
