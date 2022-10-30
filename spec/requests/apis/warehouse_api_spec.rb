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
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at")
    end

    it 'fail if warehouse not found' do
      #arrange

      #act
      get "/api/v1/warehouses/9999999"
      #assert
      expect(response.status).to eq 404
    end
    
  end

  context 'GET /api/v1/warehouses/1' do #endpoint
    it 'list all warehouses ordered by name' do
      #arrange
      Warehouse.create(name: 'Rio',code: 'SDU', city: 'Rio de Janeiro', area: 60_000, cep: "54000000", address:'Avenida beira mar, 1000', description: 'Galpão destinado à cargas de eletrônicos.')
      Warehouse.create(name: 'Maceio',code: 'MCZ', city: 'Maceio', area: 50_000, cep: "31000000", address:'Avenida beira mar, 2000', description: 'Galpão destinado à cargas de brinquedos.')

      #act
      get '/api/v1/warehouses'
      #assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq 'Maceio'
      expect(json_response[1]["name"]).to eq 'Rio'

    end

    it 'return empty if there is no warehouse' do
      #arrange
      #act
      get '/api/v1/warehouses'
      #assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'raise internal error' do
      #arrange
      allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      #act
      get '/api/v1/warehouses'
      #assert
      expect(response).to have_http_status(500)

    end
  end

  context 'POST /api/v1/warehouses/1' do
    it 'it success' do
      #arrange
      warehouse_params = { warehouse: { name: 'Aeroporto Internacional', code: 'GRU',
                                        city: 'Guarulhos', area: 100000, address: 'Avenida do Aeroporto, 1000', cep: '15000000', 
                                        description: 'Galpão destinado à cargas internacionais' }
                          }
                          
      #act
      post '/api/v1/warehouses', params: warehouse_params
      #assert
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq ('Aeroporto Internacional')
      expect(json_response["code"]).to eq ('GRU')
      expect(json_response["city"]).to eq ('Guarulhos')
      expect(json_response["area"]).to eq (100000)
      expect(json_response["address"]).to eq ('Avenida do Aeroporto, 1000')
      expect(json_response["cep"]).to eq ('15000000')
      expect(json_response["description"]).to eq ('Galpão destinado à cargas internacionais')
    end

    it 'fail if parameters are incomplete' do
      #arrange
      warehouse_params = { warehouse: { name: 'Aeroporto Curitiba', code: 'CWB'}}
      #act
      post '/api/v1/warehouses', params: warehouse_params
      #assert
      expect(response).to have_http_status(412)
      expect(response.body).not_to include 'Nome não pode ficar em branco'
      expect(response.body).not_to include 'Código não pode ficar em branco'
      expect(response.body).to include 'Cidade não pode ficar em branco'
      expect(response.body).to include 'Endereço não pode ficar em branco'
    end

    it 'fail if theres an internal error' do
      #arrange
      allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      warehouse_params = { warehouse: { name: 'Aeroporto Internacional', code: 'GRU',
                                        city: 'Guarulhos', area: 100000, address: 'Avenida do Aeroporto, 1000', cep: '15000000', 
                                        description: 'Galpão destinado à cargas internacionais' }
                          }
      #act
      post '/api/v1/warehouses', params: warehouse_params
      #assert
      expect(response).to have_http_status(500)
    end


  end
end




# it 'e não há produtos cadastrados' do
#   #arrange
#   #act
#   get '/api/v1/products/'
#   #assert
#   expect(response).to have_http_status 200
#   expect(response.content_type).to include 'application/json'
#   expect(response.body).to eq "[]"
# end

# it 'e ocorre um erro interno' do 
#   categoria = ProductCategory.create!(
#                                       name: 'Sobremesas'

#                                   )
#   Product.create!(
#                   name: 'Bombom de chocolate',
#                   price: 5,
#                   product_category: categoria
#                 )

#   get '/api/v1/products/'

#   expect(response).to have_http_status 500
# end


