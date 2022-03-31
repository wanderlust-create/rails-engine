# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Item Search with API' do
  context 'returns a single item which matches the search term' do
    it 'GET/ item with FIND by min-price' do
      merchant1 = Merchant.create!(name: 'Lama Leaping')
      merchant2 = Merchant.create!(name: 'Monkey Moaping')
      item1 = Item.create!(name: 'One Item', description: 'apple-one', unit_price: 12.77, merchant_id: merchant1.id)
      item2 = Item.create!(name: 'Apple Item', description: 'one-two', unit_price: 23.11, merchant_id: merchant1.id)
      item3 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)
      item4 = Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)
      item5 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)

      search_by = { min_price: 25.00 }

      get '/api/v1/items/find', params: search_by

      expect(response).to have_http_status(200)

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item.count).to eq 1
      expect(item[0][:type]).to eq('item')
      expect(item[0][:attributes][:name]).to eq('Four Item')
      expect(item[0][:attributes][:description]).to eq('four')
      expect(item[0][:attributes][:unit_price]).to eq 32.77
      expect(item[0][:attributes][:merchant_id]).to eq(merchant2.id)
    end

    it 'GET/ item with FIND returns 1 item searching name and description' do
      merchant1 = Merchant.create!(name: 'Lama Leaping')
      merchant2 = Merchant.create!(name: 'Monkey Moaping')
      item1 = Item.create!(name: 'One Item', description: 'apple-one', unit_price: 12.77, merchant_id: merchant1.id)
      item2 = Item.create!(name: 'Apple Item', description: 'one-two', unit_price: 23.11, merchant_id: merchant1.id)
      item3 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)
      item4 = Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)
      item5 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)

      get '/api/v1/items/find', params: { name: 'apple' }

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item.count).to eq 1
      expect(item[0][:type]).to eq('item')
      expect(item[0][:attributes][:name]).to eq('Apple Item')
      expect(item[0][:attributes][:description]).to eq('one-two')
      expect(item[0][:attributes][:unit_price]).to eq 23.11
      expect(item[0][:attributes][:merchant_id]).to eq(merchant1.id)
    end
  end
end
