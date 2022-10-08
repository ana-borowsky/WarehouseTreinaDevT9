class StockProduct < ApplicationRecord
  belongs_to :warehouse
  belongs_to :order
  belongs_to :product_model
  has_one :stock_product_destination

  before_validation :generate_serial_number, on: :create

  def available?
    if stock_product_destination.nil?
      return true
    end
    return false
    #as 4 linhas de cima poderiam ser resumidas por
    #stock_products_destination.nil?
  end

  private

  def generate_serial_number
    self.serial_number = SecureRandom.alphanumeric(20).upcase
  end
end
