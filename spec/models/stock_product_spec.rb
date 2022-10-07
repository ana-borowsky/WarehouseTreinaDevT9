require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um numero de serie' do
    it 'ao criar um StockProduct' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
     
      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: :delivered)

      product_model = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345678')

      #act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_model)
      #assert
      expect(stock_product.serial_number.length).to eq 20

    end

    it 'e este numero nao e modificado' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      other_warehouse = Warehouse.create!(name:'Porto Alegre Sul', code: 'POA', city: 'Porto Alegre', area: 30_000, address: 'Avenida dos imigrantes, 100', cep: '32000000', 
                                          description: 'Galpão destinado à cargas do sul')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: :delivered)

      product_model = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345678')
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_model)
      original_serial_number = stock_product.serial_number
      #act
      stock_product.update(warehouse: other_warehouse)
     
      #assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end
end
