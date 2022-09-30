require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    #arrange
    #act
    visit root_path
    click_on 'Log in'
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Maria Flor'
    fill_in 'E-mail', with: 'maria@gmail.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'
    #assert
    expect(page).to have_content 'Registro realizado com sucesso.'
    expect(page).to have_content 'maria@gmail.com' 
    expect(page).to have_button 'Log out'
  end
end