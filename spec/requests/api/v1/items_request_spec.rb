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

  describe 'POST/ item' do
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

    context 'given incomplete information' do
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
end

RSpec.describe 'Item Search with API' do

  context 'GET/ item with FIND' do

    let(:merchant1) { Merchant.create!(name: 'Lama Leaping') }
    let(:merchant2) { Merchant.create!(name: 'Monkey Moaping') }
    let(:item1) {Item.create!(name: 'One Item', description: 'one', unit_price: 12.77, merchant_id: merchant1.id)}
    let(:item2) {Item.create!(name: 'Two Item', description: 'two', unit_price: 23.11, merchant_id: merchant1.id)}
    let(:item3) {Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)}
    let(:item4) {Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)}
    let(:item5) {Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)}

    it 'returns a single item which matches the search term' do
      search_by = { min_price: 25.00 }

      get '/api/v1/items/find', params: search_by

      expect(response).to have_http_status(200)

      item = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry
    end
  end


end
