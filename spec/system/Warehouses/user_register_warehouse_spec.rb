require 'rails_helper'

describe 'Usuário cadastra um galpão' do
  it 'a partir da tela inicial' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    #act
    login_as(user)
    visit(root_path)
    click_on 'Cadastrar Galpão'

    #assert
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Código'
    expect(page).to have_content 'Cidade'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Endereço'
    expect(page).to have_content 'Área'
    expect(page).to have_content 'CEP'
  end

  it 'com sucesso' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    #act
    login_as(user)
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: 'Rio'
    fill_in 'Descrição', with: 'Galpão da zona portuária do Rio'
    fill_in 'Código', with: 'RIO'
    fill_in 'Endereço', with: 'Avenida do Amanhã, 2000'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'CEP', with: '32400000'
    fill_in 'Área', with: '10000'
    click_on 'Enviar'

    #assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Rio de Janeiro'
    expect(page).to have_content 'RIO'
    expect(page).to have_content '10000'
  end
end

