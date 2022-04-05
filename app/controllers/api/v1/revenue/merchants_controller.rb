# frozen_string_literal: true

class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].to_i < 1 || params[:quantity] == '' || params[:quantity] == ['']
      render json: { error: 'need to add a number of merchants', data: {} }, status: :bad_request
    elsif
      number = params[:quantity]
      top_merchants = Merchant.top_merchants_by_revenue(number)
      render json: MerchantNameRevenueSerializer.new(top_merchants)
    end
  end
end
