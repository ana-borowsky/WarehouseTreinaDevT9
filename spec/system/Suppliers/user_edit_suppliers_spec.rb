require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'a partir da página de detalhes' do
    #Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    s = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                        email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                        registration_number: '33333333333333', state: 'Rio Grande do Sul')

    #Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on 'Looney Tunes'
    click_on 'Editar'

    #Assert
    expect(page).to have_content('Editar Fornecedor')
    expect(page).to have_field('Razão social', with: 'Looney Tunes')
    expect(page).to have_field('Nome fantasia', with: 'Pernalonga')
    expect(page).to have_field('Cidade', with: 'Mato Leitão')
    expect(page).to have_field('Estado', with: 'Rio Grande do Sul')
    expect(page).to have_field('Endereço', with: 'O que é que há, velhinho, 29')
    expect(page).to have_field('CNPJ', with: '33333333333333')
  end

  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    s = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
    email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
    registration_number: '33333333333333', state: 'Rio Grande do Sul')

    #Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on 'Looney Tunes'
    click_on 'Editar'
    fill_in 'Razão social', with: 'Warner'
    fill_in 'Nome fantasia', with: 'Patolino'
    fill_in 'Estado', with: 'Pará'
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Fornecedor editado com sucesso!'

    #como ficam esses testes? pq não volta para a root_path 	
    #expect(page).to have_content 'Razão social: Warner'
    #expect(page).to have_content 'Nome fantasia: Patolino'
    #expect(page).to have_content 'Pará'
  end

  it 'e mantém os campos obrigatórios' do
    #Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    s = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
    email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
    registration_number: '33333333333333', state: 'Rio Grande do Sul')

    #Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on 'Looney Tunes'
    click_on 'Editar'
    fill_in 'Razão social', with: ''
    fill_in 'Nome fantasia', with: ''
    fill_in 'Estado', with: ''
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Não foi possível atualizar o fornecedor.'
  end
end




