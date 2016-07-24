class LineItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :line_items
  belongs_to :product, inverse_of: :line_items

  validates_presence_of :order, :product

  after_create :decrement_product_quantity!

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end
end
