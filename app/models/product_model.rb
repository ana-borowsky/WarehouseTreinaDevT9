class ProductModel < ApplicationRecord
  belongs_to :supplier
  validates :name, :depth, :weight, :width, :height, :sku, presence: true
  validates :sku, uniqueness: true
  validates :sku, length: { is: 14 }
  validates :depth, :weight, :width, :height, numericality: { greater_than: 0 } 
end


