require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'mostra nome mais email' do
      #arrange
      u = User.new(name:'Julia Almeida', email:'julia@almeida.com')
      #act
      result = u.description()
      #assert
      expect(result).to eq('Julia Almeida - julia@almeida.com')
    end
  end
 
end
