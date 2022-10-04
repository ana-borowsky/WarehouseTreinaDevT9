class ProductModel < ApplicationRecord
  belongs_to :supplier
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, :depth, :weight, :width, :height, :sku, presence: true
  validates :sku, uniqueness: true
  validates :sku, length: { is: 14 }
  validates :depth, :weight, :width, :height, numericality: { greater_than: 0 } 
end


