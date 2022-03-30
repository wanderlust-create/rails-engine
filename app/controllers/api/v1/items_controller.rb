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
          render json: {error: "Missing Information", code: 400 }, status: :bad_request
        end
      end 

      private
      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
