require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
   
    #act
    login_as(user)
    visit root_path
    click_on 'Log out'
    fill_in 'E-mail', with: 'catatau@adoromel.com'
    fill_in 'Senha', with: 'adoromel'
    click_button 'Log in'
    
    #assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Log in'
      expect(page).to have_button 'Log out'
      expect(page).to have_content 'catatau@adoromel.com'
    end
  end

  it 'e faz logout' do
    #arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
   
    #act
    login_as(user)
    visit root_path
    click_on 'Log out'

    #assert
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    within('nav') do
      expect(page).to have_link 'Log in'
      expect(page).not_to have_button 'Log out'
      expect(page).not_to have_content 'catatau@adoromel.com' 
    end
  end
end