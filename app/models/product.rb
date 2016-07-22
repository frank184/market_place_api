class Product < ActiveRecord::Base
  belongs_to :user
  
  has_many :line_items
  has_many :orders, through: :line_items

  validates_presence_of :title, :price, :user
  validates_numericality_of :price, greater_than_or_equal_to: 0

  scope :by_title, ->(title) { where 'lower(title) LIKE ?', "%#{title.downcase}%" }
  scope :greater_than_or_equal_price, ->(price) { where 'price >= ?', price }
  scope :less_than_or_equal_price, ->(price) { where 'price <= ?', price }
  scope :latest, -> { order :updated_at }


  def self.search(params={})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    products = products.by_title(params[:title]) if params[:title]
    products = products.greater_than_or_equal_price(params[:min_price].to_f) if params[:min_price]
    products = products.less_than_or_equal_price(params[:max_price].to_f) if params[:max_price]
    products = products.latest if params[:latest].present? && params[:latest] == true
    products
  end
end
