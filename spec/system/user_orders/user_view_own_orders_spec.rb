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
    first_order = Order.new(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    second_order = Order.new(user: ze_colmeia, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    third_order = Order.new(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #act
    login_as(catatau)
    visit root_path
    click_on 'Meus pedidos'
    #assert
    expect(page).to have_content first_order.code
    expect(page).not_to have_content second_order.code
    expect(page).to have_content third_order.code    
  end
end