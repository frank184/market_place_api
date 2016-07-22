class LineItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :line_items
  belongs_to :product, inverse_of: :line_items

  validates_presence_of :order, :product
end
