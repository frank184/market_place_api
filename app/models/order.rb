class Order < ActiveRecord::Base
  belongs_to :user

  has_many :line_items
  has_many :products, through: :line_items

  validates_presence_of :user
  # validates_presence_of :total
  # validates_numericality_of :total, greater_than_or_equal_to: 0

  before_validation :generate_total

  def generate_total
    self.total = products.map(&:price).sum
  end
end
