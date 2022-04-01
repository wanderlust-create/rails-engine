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

      def merchant_exist(params)
        if !Merchant.exists?(params[:merchant_id])
          render json: { error: 'Merchant does not exist'}, status: :not_found
        else
          render json: ItemSerializer.new(Item.update(params[:id], item_params))
        end
      end

      def update
        if params[:merchant_id]
          merchant_exist(params)
        else
          render json: ItemSerializer.new(Item.update(params[:id], item_params))
        end
      end

      def create
        new_item = Item.new(item_params)
        if new_item.save
          render json: ItemSerializer.new(new_item), status: :created
        else
          render json: { error: 'Missing Information', code: 400 }, status: :bad_request
        end
      end

      def destroy
        item = Item.find(params[:id])
        invoices = item.invoices
        invoices.each do |invoice|
          invoice.destroy if invoice.invoice_items.count <= 1
        end
        item.destroy
        render json: { message: 'item destroyed' }, status: 204
      end

      def find_by
        if params[:name] && params[:min_price] && params[:max_price]
          render json: { error: 'cannot send both name and min_price and max_price', code: 400 }, status: :bad_request

        elsif params[:name] && params[:min_price]
          render json: { error: 'cannot send both name and min_price', code: 400 }, status: :bad_request

        elsif params[:name] && params[:max_price]
          render json: { error: 'cannot send both name and max_price', code: 400 }, status: :bad_request

        elsif params[:max_price] && params[:min_price] && params[:min_price].to_f > params[:max_price].to_f
          render json: { error: 'min_price cannot be more than max_price', code: 400 }, status: :bad_request

        elsif params[:max_price].to_f.negative? || params[:min_price].to_f.negative?
          render json: { error: 'request cannot be lower than 0', data: {}, code: 400 }, status: :bad_request

        elsif params[:name] == '' || params[:max_price] == '' || params[:min_price] == ''
          render json: { error: 'parameter cannot be empty', code: 400 }, status: :bad_request

        elsif params['']
          render json: { error: 'parameter cannot be missing', code: 400 }, status: :bad_request

        else
          search_params = { name: params[:name], min_price: params[:min_price], max_price: params[:max_price] }
          @item = Item.search(search_params)
          if @item == []
            render json: { message: 'no item fits your request', data: {}, code: 200 }, status: :ok
          elsif @item.count.positive?
            render json: ItemSerializer.new(Item.find(@item[0].id))
          end
        end
      end

      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
