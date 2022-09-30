require 'rails_helper'

  describe 'Usuário cadastra um fornecedor' do
    it 'a partir da tela inicial'do
      # Arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      # Act
      login_as(user)
      visit root_path
      click_on 'Fornecedores'
      click_on 'Cadastrar Fornecedor'

      # Assert
      expect(page).to have_field('Razão social')
      expect(page).to have_field('Nome fantasia')
      expect(page).to have_field('CNPJ')
      expect(page).to have_field('Endereço')
      expect(page).to have_field('Cidade')
      expect(page).to have_field('Estado')
      expect(page).to have_field('Email')
    end

    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      # Act
      login_as(user)
      visit root_path
      click_on 'Fornecedores'
      click_on 'Cadastrar Fornecedor'
      fill_in 'Razão social', with: 'ACME'
      fill_in 'Nome fantasia', with: 'Coyote'
      fill_in 'CNPJ', with: '11111111111111'
      fill_in 'Endereço', with: 'Avenida dos Papa-léguas, 1234'
      fill_in 'Cidade', with: 'Não-Me-Toque'
      fill_in 'Estado', with: 'Rio Grande do Sul'
      fill_in 'Email', with: 'coyotegenio@acme.com'
      click_on 'Enviar'

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Fornecedor cadastrado com sucesso!'
      click_on 'Fornecedores'
      expect(page).to have_content 'ACME'
      expect(page).to have_content 'Coyote'
      expect(page).to have_content 'Não-Me-Toque, Rio Grande do Sul'
    end

    it 'com dados incompletos' do
      # Arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      # Act
      login_as(user)
      visit root_path
      click_on 'Fornecedores'
      click_on 'Cadastrar Fornecedor'
      fill_in 'Razão social', with: ''
      fill_in 'CNPJ', with: ''
      click_on 'Enviar'

      # Assert
      expect(page).to have_content 'Fornecedor NÃO cadastrado!'
      expect(page).to have_content 'Razão social não pode ficar em branco'      
      expect(page).to have_content 'Nome fantasia não pode ficar em branco'     
      expect(page).to have_content 'CNPJ não pode ficar em branco'     
      expect(page).to have_content 'Endereço não pode ficar em branco'     
      expect(page).to have_content 'Estado não pode ficar em branco'     
      expect(page).to have_content 'Cidade não pode ficar em branco'   
      expect(page).to have_content 'Email não pode ficar em branco'       
    end
end
