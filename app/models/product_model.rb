class ProductModel < ApplicationRecord
  belongs_to :supplier
  validates :name, :weight, :width, :height, :sku, presence: true
  validates :sku, uniqueness: true
  validates :sku, length: { is: 14 }
end


