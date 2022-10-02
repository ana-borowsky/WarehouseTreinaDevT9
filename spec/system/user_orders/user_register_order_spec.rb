require 'rails_helper'
  describe 'Usuario cadastra pedido' do

    it 'e deve estar autenticado' do
      #arrange
      #act
      visit root_path
      click_on 'Registrar pedido'
      #assert
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end

    it 'com sucesso' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
      Warehouse.create!(name:'Porto Alegre Sul', code: 'POA', city: 'Porto Alegre', area: 30_000, address: 'Avenida dos imigrantes, 100', cep: '32000000', 
                        description: 'Galpão destinado à cargas do sul')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      Supplier.create!(corporate_name:'Warner', brand_name: 'Coyote', city: 'Nao-me-toque', email: 'coyote@genio.com', full_address: 'rua dos papa-leguas, 42', 
                      registration_number: '33333333333334', state: 'Rio Grande do Sul')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ASDCF12345')
      #act
      login_as(user)
      visit root_path
      click_on 'Registrar pedido'
      select 'CDZ - Cuiaba', from: 'Galpão de destino'
      select supplier.corporate_name, from: 'Fornecedor'
      fill_in 'Previsão de entrega', with: 1.day.from_now
      click_on 'Gravar'
      #assert
      expect(page).to have_content 'Pedido realizado com sucesso.'
      expect(page).to have_content 'Numero do pedido ASDCF12345'
      expect(page).to have_content 'Galpão de destino: CDZ - Cuiaba'
      expect(page).to have_content 'Fornecedor: Looney Tunes'
      expect(page).to have_content 'Usuario responsavel: Catatau | catatau@adoromel.com'
      expect(page).to have_content "Previsão de entrega:  #{order.estimated_delivery_date}"

    end
  end