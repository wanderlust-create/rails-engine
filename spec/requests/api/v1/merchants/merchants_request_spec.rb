# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Merchant API' do
  describe 'GET/ Merchants' do
    it 'sends a list of all merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to have_http_status(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq 3

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an String

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
      end
    end
  end

  describe 'GET/ One Merchant' do
    it 'sends attributes of one merchant' do
      merchant1 = Merchant.create(name: 'Joe Happy')

      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to have_http_status(200)

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an String

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq('Joe Happy')
    end
  end
end
