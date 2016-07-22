require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { include_default_accept_headers }

  describe "GET #show" do
    before(:each) do
      @user = create :user
      get :show, id: @user.id
    end

    it "should return the user as JSON" do
      user_response = json_response
      expect(user_response[:user][:email]).to eql @user.email
    end

    it "should have product_ids" do
      user_response = json_response
      expect(user_response[:user][:product_ids]).to eql []
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when created" do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "should render the user created as JSON" do
        user_response = json_response
        expect(user_response[:user][:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @invalid_attributes = attributes_for :user, email: nil
        post :create, { user: @invalid_attributes }
      end

      it "should render the errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "should explain why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    context "when updated" do
      before(:each) do
        @user = create :user
        api_authorization_header @user.token
        patch :update, { id: @user.id, user: {email: 'new@mail.com'} }
      end

      it "should render the updated user as JSON" do
        user_response = json_response
        expect(user_response[:user][:email]).to eql 'new@mail.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context "when not updated" do
      before(:each) do
        @user = create :user
        request.headers['Authorization'] = @user.token
        patch :update, { id: @user.id, user: {email: 'bad'} }
      end

      it "should render the errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "should explain why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = create :user
      api_authorization_header @user.token
      delete :destroy, { id: @user.id }
    end

    it { is_expected.to respond_with 204 }
  end

end
