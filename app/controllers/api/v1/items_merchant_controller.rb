# frozen_string_literal: true

module Api
  module V1
    class ItemsMerchantController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.find_by(params[:merchant_id]))
      end
    end
  end
end
