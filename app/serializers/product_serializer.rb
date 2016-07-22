class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :published
  belongs_to :user, include: true
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :created_at, :updated_at
  end
end
