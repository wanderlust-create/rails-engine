# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Item Search with API' do
  describe 'returns a single item which matches the search term' do
    it 'GET/ item with FIND by min-price and will choose first item alphabetically' do
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

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq 1
      expect(item[:data][:type]).to eq('item')
      expect(item[:data][:attributes][:name]).to eq('Five Item')
      expect(item[:data][:attributes][:description]).to eq('five')
      expect(item[:data][:attributes][:unit_price]).to eq 175.7
      expect(item[:data][:attributes][:merchant_id]).to eq(merchant2.id)
    end

    it 'GET/ item with FIND by max-price and will choose first item alphabetically' do
      merchant1 = Merchant.create!(name: 'Lama Leaping')
      merchant2 = Merchant.create!(name: 'Monkey Moaping')
      item1 = Item.create!(name: 'One Item', description: 'apple-one', unit_price: 12.77, merchant_id: merchant1.id)
      item2 = Item.create!(name: 'Apple Item', description: 'one-two', unit_price: 23.11, merchant_id: merchant1.id)
      item3 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)
      item4 = Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)
      item5 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)

      search_by = { max_price: 30.00 }

      get '/api/v1/items/find', params: search_by

      expect(response).to have_http_status(200)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq 1
      expect(item[:data][:attributes][:name]).to eq('Apple Item')
      expect(item[:data][:attributes][:unit_price]).to eq 23.11
    end

    it 'GET/ item with FIND between min-price/ max_price and will choose first item alphabetically' do
      merchant1 = Merchant.create!(name: 'Lama Leaping')
      merchant2 = Merchant.create!(name: 'Monkey Moaping')
      item1 = Item.create!(name: 'One Item', description: 'apple-one', unit_price: 12.77, merchant_id: merchant1.id)
      item2 = Item.create!(name: 'Apple Item', description: 'one-two', unit_price: 23.11, merchant_id: merchant1.id)
      item3 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)
      item4 = Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)
      item5 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)

      search_by = { min_price: 50.00, max_price: 200.00 }

      get '/api/v1/items/find', params: search_by

      expect(response).to have_http_status(200)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq 1
      expect(item[:data][:attributes][:name]).to eq('Five Item')
      expect(item[:data][:attributes][:unit_price]).to eq 175.7
    end

    it 'GET/ item with FIND returns 1 item searching both the name and description keys' do
      merchant1 = Merchant.create!(name: 'Lama Leaping')
      merchant2 = Merchant.create!(name: 'Monkey Moaping')
      item1 = Item.create!(name: 'Cappy Item', description: 'one', unit_price: 12.77, merchant_id: merchant1.id)
      item2 = Item.create!(name: 'Bobcat Item', description: 'apple-two', unit_price: 23.11, merchant_id: merchant1.id)
      item3 = Item.create!(name: 'Zed Item', description: 'three', unit_price: 1.7, merchant_id: merchant2.id)
      item4 = Item.create!(name: 'Four Item', description: 'four', unit_price: 32.77, merchant_id: merchant2.id)
      item5 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant2.id)

      get '/api/v1/items/find', params: { name: 'Apple' }

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq 1
      expect(item[:data][:type]).to eq('item')
      expect(item[:data][:attributes][:name]).to eq('Bobcat Item')
      expect(item[:data][:attributes][:description]).to eq('apple-two')
      expect(item[:data][:attributes][:unit_price]).to eq 23.11
      expect(item[:data][:attributes][:merchant_id]).to eq(merchant1.id)

      get '/api/v1/items/find', params: { name: 'zed' }

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq 1
      expect(item[:data][:attributes][:name]).to eq('Zed Item')
      expect(item[:data][:attributes][:unit_price]).to eq 1.7
    end
  end
end
