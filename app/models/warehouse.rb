class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :cep, :address, :area, presence: true
  validates :code, :name, uniqueness: true
  validates :code, length: { is: 3 }
  validates :area, numericality: true 
  validates :cep, length: { is: 8 }

  def full_description
    "#{code} - #{name}"
  end
end
