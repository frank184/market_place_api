class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :published
  belongs_to :user, include: true

  cache

  def cache_key
    [object, scope]
  end
end
