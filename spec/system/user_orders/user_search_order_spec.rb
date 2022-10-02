require 'rails_helper'
describe 'Usuario busca por um pedido' do
  it 'a partir do menu' do
    #arrange
    user = User.create!(name: 'Maria', email: 'maria@mole.com', password: 'password')
    #act
    login_as(user)
    visit root_path
    #assert
    within('header nav') do
      expect(page).to have_field('Buscar pedido')
      expect(page).to have_button('Buscar')
    end
  end
  it 'e deve estar autenticado' do
    #arrange

    #act
    visit root_path
    fill_in 'Buscar pedido', with: 'ASDFG12345'
    click_on 'Buscar'

    #assert
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  
  end

  it 'e encontra um pedido' do
    #arrange
    user = User.create!(name: 'Maria', email: 'maria@mole.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #act
    login_as(user)
    visit root_path
    fill_in 'Buscar pedido', with: order.code
    click_on 'Buscar'
    #assert
    expect(page).to have_content "Resultado da busca por: #{order.code}"
    expect(page).to have_content "Codigo: #{order.code}"
    expect(page).to have_content "Galpao destino: CDZ - Cuiaba"
    expect(page).to have_content "Fornecedor: Pernalonga"
    expect(page).to have_button('Buscar')
  end

  it 'e encontra multiplos resultados' do
    #arrange
    user = User.create!(name: 'Maria', email: 'maria@mole.com', password: 'password')

    first_warehouse = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', address: 'Avenida dos guararapes, 1000', cep:'35000000', city: 'Rio de Janeiro', area: 10000, description: 'galpão de estoque de produtos de beleza')
    second_warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')

    allow(SecureRandom).to receive(:alphanumeric).and_return('SDUCF12345')
    first_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('SDUCF67890')
    second_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('CDZ0000000')
    third_order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #act
    login_as(user)
    visit root_path
    fill_in 'Buscar pedido', with: 'SDU'
    click_on 'Buscar'
    #assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'SDUCF12345'
    expect(page).to have_content 'SDUCF67890'
    expect(page).not_to have_content 'CDZ0000000'
    expect(page).to have_content 'Galpao destino: Aeroporto Rio - SDU'
    expect(page).not_to have_content "Galpao destino: CDZ - Cuiaba"
  end
end