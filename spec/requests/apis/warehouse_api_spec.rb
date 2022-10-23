require 'rails_helper'

describe 'Warehouse API' do
  context 'GET /api/v1/warehouses/1' do
    it 'success' do
      #arrange
      warehouse = Warehouse.create!(name: 'Rio', code: 'RIO', address: 'Avenida Beira Mar, 1000', cep:'25000000', city: 'Rio de Janeiro', area: 1000, description: 'galpão de estoque')
      #act
      get "/api/v1/warehouses/#{warehouse.id}"
      #assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq('Rio')
      expect(json_response["code"]).to eq('RIO')

    end
  end
end