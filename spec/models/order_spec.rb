require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um codigo' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      result = order.valid?
      #assert
      expect(result).to be true
    end

    it 'data de entrega deve ser obrigatoria' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.new(estimated_delivery_date: '')
      #act
      order.valid?
      #assert
      expect(order.errors.include? :estimated_delivery_date).to be true
    end

    it 'data estimada deve ser futura' do
      #arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)
      #act
      order.valid?
      #assert
      expect(order.errors.include?(:estimated_delivery_date)).to be true
    end

    it 'data estimada nao deve ser igual a hoje' do
      #arrange
      order = Order.new(estimated_delivery_date: Date.today)
      #act
      order.valid?
      #assert
      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors[:estimated_delivery_date]).to include(" deve ser futura.")
    end
  end
  describe 'gera um codigo aleatorio' do
    it 'ao criar um novo pedido' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      order.save!
      result = order.code
      #assert
      expect(result).not_to be_empty
      expect(result.length).to eq 10
    end

    it 'e o codigo e unico' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      #act
      second_order.save!
      
      #assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e o codigo nao deve ser modificado' do
      #arrange
      user = User.create!(name: 'Catatau', email: 'catatau@adoromel.com', password: 'adoromel')

      warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CDZ', address: 'Avenida dos tubarões, 1000', cep:'75000000', city: 'Cuiabá', area: 1000, description: 'galpão de estoque')

      supplier = Supplier.create!(corporate_name:'Looney Tunes', brand_name: 'Pernalonga', city: 'Mato Leitão', 
                                  email: 'perna@longa.com', full_address: 'O que é que há, velhinho, 29', 
                                  registration_number: '33333333333333', state: 'Rio Grande do Sul')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now.to_date)
      original_code = order.code
      #act
      order.update!(estimated_delivery_date: 1.month.from_now)
      #assert
      expect(order.code).to eq original_code

    end
  end
end
