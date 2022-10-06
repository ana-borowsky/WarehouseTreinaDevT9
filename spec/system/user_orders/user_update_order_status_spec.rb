require 'rails_helper'

describe 'Usuario modifica status de pedido' do
  it 'para entregue' do
    #arrange
    catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')

    product_model = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345690')

    order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: 'pending')

    OrderItem.create!(order: order, product_model: product_model, quantity: 5)
    #act
    login_as(catatau)
    visit root_path
    click_on 'Meus pedidos'
    click_on order.code
    click_on 'Entregue'
    
    #assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status: Entregue'
    expect(page).not_to have_button 'Cancelado'
    expect(page).not_to have_button 'Entregue'
    expect(StockProduct.count).to eq 5
    stock = StockProduct.where(product_model: product_model, warehouse: warehouse).count
    expect(stock).to eq 5
    
  end

  it 'para cancelado' do
    #arrange
    catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')

    product_model = ProductModel.create!(name: 'Produto A', weight:1, depth: 10, height: 20, width: 25, supplier: supplier, sku: 'QWERTY12345690')

    order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date, status: 'pending')

    OrderItem.create!(order: order, product_model: product_model, quantity: 5)

    #act
    login_as(catatau)
    visit root_path
    click_on 'Meus pedidos'
    click_on order.code
    click_on 'Cancelado'
    
    #assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status: Cancelado'
    expect(StockProduct.count).to eq 0
  end
end