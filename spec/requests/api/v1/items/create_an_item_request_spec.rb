# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'POST/ item' do
  let(:merchant) { Merchant.create!(name: 'Joe Happy') }
  context 'given complete information' do
    it 'will accept a request to create an item' do
      item1_params = {
        name: 'Sunny Disposition',
        description: 'Rare right now',
        unit_price: 199.76,
        merchant_id: merchant.id
      }
      post '/api/v1/items', params: item1_params

      expect(response).to have_http_status(201)
      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes][:name]).to eq('Sunny Disposition')

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes][:description]).to eq('Rare right now')

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes][:unit_price]).to eq 199.76

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  describe 'given incomplete information' do
    it 'will return an error code when given incomplete information' do
      item2_params = {
        name: 'Sunny Disposition',
        merchant_id: merchant.id
      }
      post '/api/v1/items', params: item2_params

      expect(response).to have_http_status(400)
    end
  end
end
