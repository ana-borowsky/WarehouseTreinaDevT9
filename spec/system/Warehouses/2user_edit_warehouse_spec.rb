require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    #Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'RIO', address: 'Avenida Beira Mar, 1000', cep:'25000000', city: 'Rio de Janeiro', area: 1000, description: 'galpão de estoque')
    #Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    #Assert
    expect(page).to have_content('Editar Galpão')
    expect(page).to have_field('Nome', with: 'Rio')
    expect(page).to have_field('Código', with: 'RIO')
    expect(page).to have_field('Cidade', with: 'Rio de Janeiro')
    expect(page).to have_field('Área', with: '1000')
    expect(page).to have_field('Endereço', with: 'Avenida Beira Mar, 1000')
    expect(page).to have_field('Descrição', with: 'galpão de estoque')
    expect(page).to have_field('CEP', with: '25000000')
  end

  it 'com sucesso' do
    #Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'RIO', address: 'Avenida Beira Mar, 1000', cep:'25000000', city: 'Rio', area: 1000, description: 'galpão de estoque')
    #Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fill_in 'Nome', with: 'Galpão internacional'
    fill_in 'Descrição', with: 'Galpão destinado à cargas internacionais'
    fill_in 'Área', with: '10000'
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Nome: Galpão internacional'
    expect(page).to have_content 'Área: 10000 m2'
    expect(page).to have_content 'Galpão destinado à cargas internacionais'
    expect(page).to have_content 'Galpão editado com sucesso!'
  end

  it 'e mantém os campos obrigatórios' do
    #Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'RIO', address: 'Avenida Beira Mar, 1000', cep:'25000000', city: 'Rio', area: 1000, description: 'galpão de estoque')
    #Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Área', with: ''
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Não foi possível atualizar o galpão.'
  end
end