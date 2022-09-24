class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :cep, :address, :area, presence: true
  validates :code, uniqueness: true
end
