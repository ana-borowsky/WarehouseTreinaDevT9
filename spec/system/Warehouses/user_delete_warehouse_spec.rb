require 'rails_helper'
describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    #arrange
    warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')
    #act
    visit root_path
    click_on 'Cuiaba'
    click_on 'Remover'
    #assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso!'
    expect(page).not_to have_content 'Cuiaba'
    expect(page).not_to have_content 'CDZ'
  end

  it 'e não apaga outros galpões' do
    #arrange
    first_warehouse = Warehouse.create!(name:'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, address: 'Avenida do Aeroporto, 1000', cep: '15000000', description: 'Galpão destinado à cargas internacionais')
    second_warehouse = Warehouse.create!(name:'Cuiaba', code: 'CDZ', city: 'Cuiabá', area: 100_000, address: 'Avenida dos tubarões, 1000', cep: '65000000', description: 'Galpão destinado à cargas centrais')
    #act
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Remover'
    #assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso'
    expect(page).to have_content 'Cuiaba'
    expect(page).not_to have_content 'Aeroporto SP'

    end
end