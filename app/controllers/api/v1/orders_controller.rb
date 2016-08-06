class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    respond_with orders, meta: paginate(resource: orders, per_page: params[:per_page])
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build
    order.product_ids_quantities = params[:order][:product_ids_quantities]
    if order.save
      order.reload
      OrdersMailer.delay.create(order)
      respond_with order, status: 201, location: [:api, :user, :orders]
    else
      render json: { errors: order.errors }, status: 422
    end
  end
end
