require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    #arrange
    User.create!(email: 'ana@gmail.com', password: 'password')
    #act
    visit root_path
    click_on 'Log in'
    fill_in 'E-mail', with: 'ana@email.com'
    fill_in 'Senha', with: 'password'
    click_button 'Log in'
    #assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Log in'
      expect(page).to have_button 'Log out'
      expect(page).to have_content 'ana@gmail.com'
    end
  end

  it 'e faz logout' do
    #arrange
    User.create!(email: 'ana@gmail.com', password: 'password')
    #act
    visit root_path
    click_on 'Log in'
    fill_in 'E-mail', with: 'ana@email.com'
    fill_in 'Senha', with: 'password'
    click_button 'Log in'
    click_on 'Log out'
    #assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    within('nav') do
      expect(page).to have_link 'Log in'
      expect(page).not_to have_button 'Log out'
      expect(page).not_to have_content 'ana@gmail.com'
    end
  end
end