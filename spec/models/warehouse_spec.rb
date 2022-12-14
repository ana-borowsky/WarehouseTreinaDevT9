require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Endereço', cep:'25000-000', city: 'Rio', area: 1000, description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when code is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Endereço', cep:'25000-000', city: 'Rio', area: 1000, description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end
      
      it 'false when address is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep:'25000-000', city: 'Rio', area: 1000, description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when cep is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep:'', city: 'Rio', area: 1000, description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when city is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep:'25000-000', city: '', area: 1000, description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when area is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep:'25000-000', city: 'Rio', area: '', description: 'galpão de estoque')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when description is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep:'25000-000', city: 'Rio', area: '1000', description: '')
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq false
      end

      it 'false when code is already in use' do
        # Arrange
        first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO', address: 'Endereço', cep:'25000-000', city: 'Rio', area: 1000, description: 'galpão de estoque')
        second_warehouse = Warehouse.create(name: 'Niteroi', code: 'RIO', address: 'Rua', cep:'26000-000', city: 'Niteroi', area: 5000, description: 'outro galpão de estoque')
        # Act
        result = first_warehouse.valid?
        # Assert
        expect(result).to eq false
      end
    end
  end
  describe '#full_description' do
    it 'exibe o nome e o codigo' do
      #arrange
      w = Warehouse.new(name:'Galpao Curitiba', code:'CWB')
      #act
      result = w.full_description()
      #assert
      expect(result).to eq('CWB - Galpao Curitiba')
    end
  end
end
