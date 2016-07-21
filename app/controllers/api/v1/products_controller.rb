class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create]
  respond_to :json

  def index
    render json: { products: Product.all}
  end

  def show
    respond_with Product.find(params[:id])
  end

  def create
    product = current_user.products.build(permitted_product_params)
    if product.save
      render json: product, status: 201, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end


  private
    def permitted_product_params
      params.require(:product).permit(:title, :price, :published)
    end
end
