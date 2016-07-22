class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    email = params[:session][:email]
    password = params[:session][:password]
    user = email.present? && User.find_by(email: email)
    if user && user.valid_password?(password)
      sign_in(user)
      user.regenerate_token
      user.save
      respond_with user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by(token: params[:id])
    user.regenerate_token
    user.save
    head 204
  end
end
