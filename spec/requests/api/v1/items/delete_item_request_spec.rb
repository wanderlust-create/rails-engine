# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'DELETE item' do
  it 'can accept a request to delete an item' do
    merchant = Merchant.create!(name: 'Monkey Moaping')

    customer = Customer.create!(first_name: 'Laughs', last_name: 'Apples')

    item1 = Item.create!(name: 'Three Item', description: 'three', unit_price: 1.7, merchant_id: merchant.id)
    item3 = Item.create!(name: 'Five Item', description: 'five', unit_price: 175.7, merchant_id: merchant.id)

    invoice1 = Invoice.create!(status: 2, customer_id: customer.id)
    invoice2 = Invoice.create!(status: 2, customer_id: customer.id)

    invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 3, unit_price: 2400)
    invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 3450)
    invoice_item3 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice2.id, quantity: 1, unit_price: 14_500)

    get '/api/v1/items'

    expect(response).to have_http_status(200)

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq 2

    delete "/api/v1/items/#{item1.id}"

    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(Item.count).to eq 1
    expect { Item.find(item1.id.to_s) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
