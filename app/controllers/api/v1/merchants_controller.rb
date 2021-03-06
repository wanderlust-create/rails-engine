# frozen_string_literal: true
class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find_all
    if params[:name] == ''
      render json: { error: 'parameter cannot be empty'}, status: :bad_request
    elsif params['']
      render json: { error: 'parameter cannot be missing'}, status: :bad_request
    elsif params[:name].instance_of?(String) && params[:name].length.positive?
      search_params = { name: params[:name] }
      @merchant = Merchant.search(search_params)
      if @merchant == []
        render json: { message: 'no merchant matches that name', data: [], code: 200 }, status: :ok
      elsif @merchant.count.positive?
        render json: MerchantSerializer.new(@merchant)
      end
    end
  end
end
