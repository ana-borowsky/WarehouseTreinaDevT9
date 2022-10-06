require 'rails_helper'

describe 'Usuario adiciona itens ao pedido' do
  it 'com sucesso' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      product_a = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345678')
      product_b = ProductModel.create!(name: 'Produto B', weight:2, depth: 9, height: 19, width: 25, supplier: supplier, sku: 'QWERTY12345667')
    
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
  
      OrderItem.create!(product_model: product_a, order: order, quantity: 19)
      OrderItem.create!(product_model: product_b, order: order, quantity: 12)

      #act
      login_as user
      visit root_path
      click_on 'Meus pedidos'
      click_on order.code
      click_on 'Adicionar item'
      select 'Produto A', from: 'Produto'
      fill_in 'Quantidade', with: '8'
      click_on 'Gravar'
      #assert
      expect(current_path).to eq order_path(order.id)
      expect(page).to have_content 'Item adicionado com sucesso'
      expect(page).to have_content '8 x Produto A'
  end

  it 'e nao ve produtos de outro fornecedor' do
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
    product_b = ProductModel.create!(name: 'Produto B', weight:2, depth: 9, height: 19, width: 25, supplier: supplier_b, sku: 'QWERTY12345667')
  
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now.to_date)

    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)

    #act
    login_as user
    visit root_path
    click_on 'Meus pedidos'
    click_on order.code
    click_on 'Adicionar item'

    #assert
    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B' 
  end
end