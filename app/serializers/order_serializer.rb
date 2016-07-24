class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :product_ids
  belongs_to :user, include: true
  has_many :products, include: true, serializer: OrderProductSerializer
end
