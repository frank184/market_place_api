class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def create
    user = User.new(permitted_user_params)
    if user.save
      respond_with user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    if user.update(permitted_user_params)
      # Default is to 204 - No Content
      # respond_with user, status: 200, location: [:api, user]
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private
    def permitted_user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
