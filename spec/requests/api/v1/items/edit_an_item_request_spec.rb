# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'EDIT item' do
  it 'can accept a request to update an item' do
    merchant = Merchant.create!(name: 'Monkey Moaping')

    item1 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant.id)

    get "/api/v1/items/#{item1.id}"

    expect(response).to have_http_status(200)

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:attributes][:name]).to eq('Three Item')
    expect(item[:attributes][:description]).to eq('three')
    expect(item[:attributes][:unit_price]).to eq 1.7

    update_params = {
      unit_price: 23.15,
      description: 'three-update'
    }

    patch "/api/v1/items/#{item1.id}", params: update_params

    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(item[:attributes][:name]).to eq('Three Item')
    expect(item[:attributes][:description]).to eq('three-update')
    expect(item[:attributes][:unit_price]).to eq 23.15
  end

  xit 'will respond with an error if merchant does not exist' do
    merchant = Merchant.create!(name: 'Monkey Moaping')

    item1 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant.id)

    update_params2 = {
      unit_price: 23.15,
      merchant_id: merchant2.id
    }

    patch "/api/v1/items/#{item1.id}", params: update_params2
    expect(response).to have_http_status(400)
  end

  xit 'will respond with an error if the data type is incorrect' do
    merchant = Merchant.create!(name: 'Monkey Moaping')

    item1 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant.id)

    get "/api/v1/items/#{item1.id}"

    expect(response).to have_http_status(200)

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item[:attributes][:name]).to eq('Three Item')
    expect(item[:attributes][:description]).to eq('three')
    expect(item[:attributes][:unit_price]).to eq 1.7

    update_params3 = {
      unit_price: 'string',
      description: 1234
    }

    patch "/api/v1/items/#{item1.id}", params: update_params3

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to have_http_status(400)
  end
end
