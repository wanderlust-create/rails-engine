# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Item API' do
  it 'sends a list of all items' do
    create_list(:item, 3)

    get '/api/v1/items'
    expect(response).to be_successful
  end
end
