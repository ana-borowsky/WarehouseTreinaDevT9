require 'rails_helper'

describe 'Usuário vê modelos de produtos' do
  it 'a partir do menu' do
    #arrange
    #act
    visit root_path
    within ('nav') do
      click_on 'Modelos de produtos'
    end
    #assert
    expect(current_path).to eq product_models_path
  end

  it 'com sucesso' do
    #arrange
    supplier = Supplier.create!(brand_name:'Samsung', corporate_name: 'Samsung Eletronicos LTDA', 
                                registration_number: '15462839405843', full_address: 'Avenida das nações, 300', 
                                city: 'São Paulo', state: 'SP', email: 'contato@samsung.com')

    ProductModel.create!(name:'TV 32"', weight: 8000, width: 70, height: 45, depth: 10,
                        sku: 'TV32-samsu-xpt', supplier: supplier)
    ProductModel.create!(name:'Soundbar 7.1', weight: 3000, width: 80, height: 15, depth: 15,
                        sku: 'Sou71-samsu-no', supplier: supplier)

    #act
    visit root_path
    within ('nav') do
      click_on 'Modelos de produtos'
    end
    #assert
    expect(page).to have_content 'TV 32"'
    expect(page).to have_content 'TV32-samsu-xpt'
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'Soundbar 7.1'
    expect(page).to have_content 'Sou71-samsu-no'
  end

  it 'e não existem produtos cadastrados' do
    #arrange
    #act
    visit root_path
    click_on 'Modelos de produtos'
    #assert
    expect(page).to have_content 'Nenhum modelo de produto cadastrado.'
  end
end
