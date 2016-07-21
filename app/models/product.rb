class Product < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :price, :user
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
