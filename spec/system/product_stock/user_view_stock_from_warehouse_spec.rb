require 'rails_helper'

describe 'Usuario ve o estoque' do
  it 'na tela do galpao' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    supplier_a = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    supplier_b = Supplier.create!(corporate_name:'Disney', brand_name: 'Mickey', city: 'Trombudo', 
                                  email: 'mickey@disney.com', full_address: 'Rua dos queijos, 200', 
                                  registration_number: '33333333333331', state: 'Santa Catarina')
    product_a = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier_a, sku: 'QWERTY12345678')
    product_b = ProductModel.create!(name: 'Produto B', weight:2, depth: 9, height: 19, width: 24, supplier: supplier_b, sku: 'QWERTY12345667')
    product_c = ProductModel.create!(name: 'Produto C', weight:3, depth: 8, height: 18, width: 23, supplier: supplier_b, sku: 'QWERTY12345645')

    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now.to_date)

    3.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a) }
    2.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_b) }

    #act
    login_as user
    visit root_path
    click_on 'Cuiaba'

    #assert
    within("section#stock_products") do
      expect(page).to have_content 'Itens em estoque'
      expect(page).to have_content '3 x Produto A - QWERTY12345678'
      expect(page).to have_content '2 x Produto B - QWERTY12345667'
      expect(page).not_to have_content 'QWERTY12345645'
    end
  end

  it 'e da baixa em um item' do
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    supplier_a = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
  
    product_a = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier_a, sku: 'QWERTY12345678')
   
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now.to_date)

    2.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a) }

    #act
    login_as user
    visit root_path
    click_on 'Cuiaba'
    select 'QWERTY12345678', from: 'Item para saida'
    fill_in 'Destinatario', with: 'Maria da Fonseca'
    fill_in 'Endereco de destino', with: 'Rua dos Pinheiros, 1000, Curitiba, Parana'
    click_on 'Confirmar retirada'

    #assert
    expect(current_path).to eq warehouse_path(warehouse.id)
    expect(page).to have_content 'Item retirado com sucesso.'
    expect(page).to have_content '1 x Produto A - QWERTY12345678'


  end
end