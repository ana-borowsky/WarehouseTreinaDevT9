require 'rails_helper'
  describe 'Usuario cadastra pedido' do
    it 'e deve estar autenticado' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      
      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      visit edit_order_path(order.id)
      #assert
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end

    it 'com sucesso' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      
      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      second_supplier = Supplier.create!(corporate_name:'Warner', brand_name: 'Coyote', city: 'Nao-me-toque', email: 'coyote@genio.com', full_address: 'rua dos papa-leguas, 42', 
                                    registration_number: '33333333333334', state: 'Rio Grande do Sul')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      login_as(user)
      visit root_path
      click_on 'Meus pedidos'
      click_on order.code
      click_on 'Editar'
      fill_in 'Previsão de entrega', with: 10.day.from_now.to_date
      select 'Coyote', from: 'Forcenedor'
      click_on 'Gravar'
      #assert
      expect(page).to have_content 'Pedido atualizado com sucesso.'
      expect(page).to have_content 'Fornecedor: Coyote'
      expect(page).to have_content 'Previsão de entrega', with: 10.day.from_now.to_date
    end

    it 'caso seja o responsavel' do
      #arrange
      catatau = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
      ze_colmeia = User.create!(name: 'Ze Colmeia', email: 'ze_colmeia@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      
      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.create!(user: ze_colmeia, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      login_as(catatau)
      visit edit_order_path(order.id)
      #assert
      expect(current_path).to eq root_path
    end
  end