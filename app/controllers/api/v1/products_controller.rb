class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def index
    products = Product.search(params).page(params[:page]).per(params[:per_page])
    respond_with products, meta: {
      pagination: {
        per_page: params[:per_page],
        total_pages: products.total_pages,
        total_objects: products.total_count
      }
    }
  end

  def show
    respond_with Product.find(params[:id])
  end

  def create
    product = current_user.products.build(permitted_product_params)
    if product.save
      respond_with product, status: 201, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = current_user.products.find(params[:id])
    if product.update(permitted_product_params)
      # Default is to 204 - No Content
      # respond_wit product, status: 200, location: [:api, product]
      render json: product, status: 200, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head 204
  end

  private
    def permitted_product_params
      params.require(:product).permit(:title, :price, :published) rescue {}
    end
end
