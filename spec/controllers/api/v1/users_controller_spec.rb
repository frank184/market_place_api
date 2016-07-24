require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { include_default_accept_headers }

  describe "GET #show" do
    before(:each) do
      @user = create :user
      get :show, id: @user.id
    end

    let(:user_response) { json_response[:user] }

    it "should return the user as JSON" do
      expect(user_response[:email]).to eql @user.email
    end

    it "should have product_ids" do
      expect(user_response).to have_key :product_ids
    end

    it "should have empty product_ids" do
      expect(user_response[:product_ids]).to eql []
    end

    it "should exclude user token" do
      expect(user_response[:token]).to be_falsey
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when created" do
      before(:each) do
        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }
      end

      let(:user_response) { json_response[:user] }

      it "should render the user created as JSON" do
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @invalid_attributes = attributes_for :user, email: nil
        post :create, { user: @invalid_attributes }
      end

      let(:user_response) { json_response }

      it "should render the errors json" do
        expect(user_response).to have_key :errors
      end

      it "should explain why the user could not be created" do
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = create :user
      api_authorization_header @user.token
    end

    context "when updated" do
      before(:each) { patch :update, {id: @user.id, user: {email: 'new@mail.com'}} }

      let(:user_response) { json_response[:user] }

      it "should render the updated user as JSON" do
        expect(user_response[:email]).to eql 'new@mail.com'
      end

      it { is_expected.to respond_with 200 }
    end

    context "when not updated" do
      before(:each) { patch :update, {id: @user.id, user: {email: 'bad'}} }

      let(:user_response) { json_response }

      it "should render the errors json" do
        expect(user_response).to have_key(:errors)
      end

      it "should explain why the user could not be created" do
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
