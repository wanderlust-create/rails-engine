# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Item API' do
  let(:merchant) { Merchant.create!(name: 'Joe Happy') }

  describe 'GET/ items' do
    it 'sends a list of all items' do
      create_list(:item, 5, merchant_id: merchant.id)

      get '/api/v1/items'

      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq 5

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a String

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an String

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an String

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_an Float

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an Integer
      end
    end
  end
end
