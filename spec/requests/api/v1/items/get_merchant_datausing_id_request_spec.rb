# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'GET/ merchant data for a given item ID' do
  it "will return merchant information for a single item" do
    merchant1 = Merchant.create!(name: 'Monkey Moaping')
    item1 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant1.id)

    get "/api/v1/items/#{item1.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

     expect(merchant[:attributes][:name]).to eq('Monkey Moaping')

    end
  end
