# frozen_string_literal: true

module Api
  module V1
    class ItemMerchantController < ApplicationController
      def index
        if !Item.exists?(params[:id])
          render json: { error: 'Item does not exist' }, status: :not_found
        else
          render json: MerchantSerializer.new(Merchant.find_by(params[:merchant_id]))
        end
      end
    end
  end
end
