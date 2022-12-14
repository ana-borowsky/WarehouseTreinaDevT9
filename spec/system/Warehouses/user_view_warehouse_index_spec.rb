require 'rails_helper'

describe 'Usuário visita tela inicial' do
    it 'e vê o nome da aplicação' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
      #act
      login_as(user)
      visit(root_path)

      #assert
      expect(page).to have_content('Galpões & Estoque')
    end

    it 'e vê os galpões cadastrados' do
      # Arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
      #cadastrar dois galpões: rio e maceió
      Warehouse.create(name: 'Rio',code: 'SDU', city: 'Rio de Janeiro', area: 60_000, cep: "54000000", address:'Avenida beira mar, 1000', description: 'Galpão destinado à cargas de eletrônicos.')
      Warehouse.create(name: 'Maceio',code: 'MCZ', city: 'Maceio', area: 50_000, cep: "31000000", address:'Avenida beira mar, 2000', description: 'Galpão destinado à cargas de brinquedos.')

      # Act
      login_as(user)
      visit(root_path)

      # Assert
      expect(page).not_to have_content('Não existem galpões cadastrados')
      expect(page).to have_content('Rio')
      expect(page).to have_content('Código: SDU')
      expect(page).to have_content('Cidade: Rio de Janeiro')
      expect(page).to have_content('60000 m2')

      expect(page).to have_content('Maceio')
      expect(page).to have_content('Cidade: Maceio')
      expect(page).to have_content('Código: MCZ')
      expect(page).to have_content('50000 m2')
    end 

    it 'e verifica que não há galpões cadastrados no momento' do
      # Arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
      # Act
      login_as(user)
      visit(root_path)

      # Assert
      expect(page).to have_content('Não existem galpões cadastrados')

    end

end
