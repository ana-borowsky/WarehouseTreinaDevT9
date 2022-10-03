require 'rails_helper'

describe 'Usuario edita um pedido' do
  it 'e nao e o dono' do
    #arrange
    catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    ze_colmeia = User.create!(name: 'Ze Colmeia', email: 'ze_colmeia@adoromel.com', password: 'adoromel')

    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    
    supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                registration_number: '33333333333333', state: 'Rio Grande do Sul')
    order = Order.create!(user: catatau, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
    #act
    login_as(ze_colmeia)
    patch(order_path(order.id), params: { order: { supplier_id: 3 } })
    #assert
    expect(response).to redirect_to(root_path)
  end
end