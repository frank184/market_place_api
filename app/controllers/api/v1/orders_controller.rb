class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build(permitted_order_params)
    if order.save
      respond_with order, status: 201, location: [:api, :user, :orders]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  private
    def permitted_order_params
      params.require(:order).permit(:total, :product_ids => [])
    end
end
