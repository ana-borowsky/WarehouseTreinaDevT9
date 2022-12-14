require 'rails_helper'
describe 'Usuario ve seus proprios pedidos' do
  it 'e deve estar autenticado' do
    #arrange

    #act
    visit root_path
    click_on 'Meus pedidos'

    #assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e nao ve outros pedidos' do
    #arrange
    catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    ze_colmeia = User.create!(name: 'Ze Colmeia', email: 'zecolmeia@adoromel.com', password: 'adoromel')


    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    first_order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: 'pending')
    second_order = Order.create!(user: ze_colmeia, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: 'canceled')
    third_order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: 'delivered')
    #act
    login_as(catatau)
    visit root_path
    click_on 'Meus pedidos'
    #assert
    expect(page).to have_content(first_order.code)
    expect(page).not_to have_content 'Ze Colmeia - zecolmeia@adoromel.com'
    expect(page).to have_content third_order.code    
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'Entregue'
    expect(page).not_to have_content 'Cancelado'

  end

  it 'e visita um pedido' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
    #act
    login_as(user)
    visit root_path
    click_on 'Meus pedidos'
    click_on order.code
    #assert
    expect(page).to have_content 'Detalhes do pedido'
    expect(page).to have_content order.code
    expect(page).to have_content 'Galpão de destino: CDZ - Cuiaba'
    expect(page).to have_content 'Fornecedor: Pernalonga'
    expect(page).to have_content "Previsão de entrega: #{I18n.localize(order.estimated_delivery_date)}"
  end

  it 'e nao visita pedidos de outros usuarios' do
    #arrange
    catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    ze_colmeia = User.create!(name: 'Ze Colmeia', email: 'zecolmeia@adoromel.com', password: 'adoromel')

    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    first_order = Order.create!(user: ze_colmeia, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
    second_order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)

    #act
    login_as(ze_colmeia)
    visit order_path(second_order.id)
 
    #assert
    expect(current_path).not_to eq order_path(second_order.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Voce nao possui acesso a este pedido.'
  end

  it 'e ve itens do pedido' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    product_a = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345678')
    product_b = ProductModel.create!(name: 'Produto B', weight:2, depth: 9, height: 19, width: 25, supplier: supplier, sku: 'QWERTY12345667')
    product_c = ProductModel.create!(name: 'Produto C', weight:3, depth: 5, height: 15, width: 30, supplier: supplier, sku: 'QWERTY12345609')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)

    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)

    #act
    login_as(user)
    visit root_path
    click_on 'Meus pedidos'
    click_on order.code
    #assert
    expect(page).to have_content 'Itens do pedido'
    expect(page).to have_content '19 x Produto A'
    expect(page).to have_content '12 x Produto B'
  end
end