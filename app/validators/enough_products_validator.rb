class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    raise NO_PRODUCTS_ERR unless record.products
    record.line_items.each do |line_item|
      product = line_item.product
      if line_item.quantity > product.quantity
        record.errors["#{product.title.parameterize('_')}"] << "is out of stock, #{product.quantity_in_words}"
      end
    end
  end
end
