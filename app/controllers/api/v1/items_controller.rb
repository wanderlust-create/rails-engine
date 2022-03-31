# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        new_item = Item.new(item_params)
        if new_item.save
          render json: ItemSerializer.new(new_item), status: :created
        else
          render json: { error: 'Missing Information', code: 400 }, status: :bad_request
        end
      end

      def find_by
        if params[:name] && params[:min_price] && params[:max_price]
          render json: { error: 'cannot send both name and min_price and max_price', code: 400 }, status: :bad_request
        elsif params[:name] && params[:min_price]
          render json: { error: 'cannot send both name and min_price', code: 400 }, status: :bad_request
        elsif params[:name] && params[:max_price]
          render json: { error: 'cannot send both name and max_price', code: 400 }, status: :bad_request
        elsif params[:name] == '' || params[:max_price] == '' || params[:min_price] == ''
          render json: { error: 'parameter cannot be empty', code: 400 }, status: :bad_request
        elsif params['']
          render json: { error: 'parameter cannot be missing', code: 400 }, status: :bad_request
        else
          search_params = { name: params[:name], min_price: params[:min_price], max_price: params[:max_price] }
          item = Item.search(search_params)
          render json: ItemSerializer.new(item)
        end
      end

      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
