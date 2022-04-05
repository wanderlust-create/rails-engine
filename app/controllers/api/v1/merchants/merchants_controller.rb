class Api::V1::Merchants::MerchantsController < ApplicationController
  def most_items
    if params[:quantity].to_i > 0
      number = params[:quantity]
      top_merchants = Merchant.top_merchants_by_items_sold(number)
      render json: ItemsSoldSerializer.new(top_merchants)
    elsif params['']
      most_items_default
    elsif
      render json: { error: 'parameter cannot be missing'}, status: :bad_request
  end
end
  def most_items_default
    top_merchants = Merchant.top_merchants_by_items_sold(5)
    render json: ItemsSoldSerializer.new(top_merchants)
  end
end
