require 'rails_helper'

describe 'Usuário vê detalhes de um fornecedor' do
  it 'e vê informações adicionais' do
    # Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    s = Supplier.new(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                    email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                    registration_number: '33333333333333', state: 'Rio Grande do Sul')
    s.save()

    # Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on('Looney Tunes')

    # Assert
    expect(page).to have_content('Looney Tunes')
    expect(page).to have_content('Pernalonga')
    expect(page).to have_content('perna@longa.com')
    expect(page).to have_content('O que é que há, velhinho, 29, Mato Leitão, Rio Grande do Sul')
    expect(page).to have_content('33.333.333/3333-33')

  end

  it 'e volta para a tela inicial' do
    # Arrange
    user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')
    s = Supplier.new(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
    email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
    registration_number: '33333333333333', state: 'Rio Grande do Sul')

    s.save()

    # Act
    login_as(user)
    visit root_path
    click_on 'Fornecedores'
    click_on 'Looney Tunes'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eq(suppliers_path)
  end
end