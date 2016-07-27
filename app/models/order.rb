class Order < ActiveRecord::Base
  belongs_to :user

  has_many :line_items
  has_many :products, through: :line_items

  validates_presence_of :user
  # validates_presence_of :total
  # validates_numericality_of :total, greater_than_or_equal_to: 0
  validates_with EnoughProductsValidator

  before_validation :generate_total

  def generate_total
    self.total = line_items.map{|line_item| line_item.product.price}.sum
  end

  def product_ids_quantities=(product_ids_quantities)
    product_ids_quantities.each do |product_id_quantity|
      product_id, quantity = product_id_quantity
      line_items.build(product_id: product_id, quantity: quantity)
    end
  end

  def product_ids_quantities
    line_items.map{|line_item| [line_item.product_id, line_item.quantity]}
  end
end
