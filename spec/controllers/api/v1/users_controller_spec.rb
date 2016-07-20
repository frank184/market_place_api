require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = 'application/vnd.marketplace.v1' }

  describe "GET #show" do
    before(:each) do
      @user = create(:user)
      get :show, id: @user.id, format: :json
    end

    it "should return the user as JSON" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when created" do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it "should render the user created as JSON" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @invalid_attributes = attributes_for :user, email: nil
        post :create, { user: @invalid_attributes }, format: :json
      end

      it "should render the errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "should explain why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    context "when updated" do
      before(:each) do
        @user = create :user
        patch :update, { id: @user.id, user: {email: 'new@mail.com'} }, format: :json
      end

      it "should render the updated user as JSON" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql 'new@mail.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context "when not updated" do
      before(:each) do
        @user = create :user
        patch :update, { id: @user.id, user: {email: 'bad'} }, format: :json
      end

      it "should render the errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "should explain why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = create :user
      delete :destroy, { id: @user.id }, format: :json
    end

    it { is_expected.to respond_with 204 }
  end

end
