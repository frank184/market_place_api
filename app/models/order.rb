class Order < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :total
  validates_numericality_of :total, greater_than_or_equal_to: 0
end
