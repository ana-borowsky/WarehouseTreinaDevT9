require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    supplier = Supplier.create!(brand_name:'Samsung', corporate_name: 'Samsung Eletronicos LTDA', 
                                registration_number: '15462839405843', full_address: 'Avenida das nações, 300', 
                                city: 'São Paulo', state: 'SP', email: 'contato@samsung.com')
    other_supplier = Supplier.create!(brand_name:'LG', corporate_name: 'LG do Brasil', 
                                registration_number: '23462839405866', full_address: 'Avenida jardim das Américas, 500', 
                                city: 'Florianópolis', state: 'C', email: 'contato@lg.com')

    #act
    login_as(user)
    visit root_path
    click_on 'Modelos de produtos'
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: 'TV 40 polegadas'
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 60
    fill_in 'Largura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV40-SAMS-XPTO'
    select 'LG', from: 'Fornecedor'
    click_on 'Enviar'
    #assert
    expect(page).to have_content 'Modelo de produto cadastrado com sucesso.'
    expect(page).to have_content 'TV 40 polegadas'
    expect(page).to have_content 'SKU: TV40-SAMS-XPTO'
    expect(page).to have_content 'Dimensões: 60cm x 90cm x 10cm'
    expect(page).to have_content 'Peso: 10000g'        
    expect(page).to have_content 'Fornecedor: LG'
  end

  it 'deve preencher todos os campos' do
    #Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    supplier = Supplier.create!(brand_name:'Samsung', corporate_name: 'Samsung Eletronicos LTDA', 
                                registration_number: '15462839405843', full_address: 'Avenida das nações, 300', 
                                city: 'São Paulo', state: 'SP', email: 'contato@samsung.com')
   
    #act
    login_as(user)
    visit root_path
    click_on 'Modelos de produtos'
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: ''
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 60
    fill_in 'Largura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: ''
    click_on 'Enviar'
    #assert
    expect(page).to have_content 'Não foi possível cadastrar o modelo de produto.'

  end
end