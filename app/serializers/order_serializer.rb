class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :product_ids
  belongs_to :user, include: true
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :created_at, :updated_at
  end
end
