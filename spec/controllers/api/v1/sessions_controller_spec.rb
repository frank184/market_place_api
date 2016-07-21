require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "POST #create" do
    before(:each) do
      include_default_accept_headers
      @user = create :user, password: 'password'
    end

    context "when valid credentials" do
      before(:each) do
        credentials = { email: @user.email, password: 'password' }
        post :create, { session: credentials }
      end

      it "should return the user with credentials" do
        @user.reload
        expect(json_response[:token]).to eql @user.token
      end

      it { is_expected.to respond_with 200 }
    end

    context "when invalid credentials" do
      context "email" do
        before(:each) do
          credentials = { email: 'not@mail.com', password: 'password' }
          post :create, { session: credentials }
        end

        it "should return an errors json with Invalid email or password" do
          expect(json_response[:errors]).to eql "Invalid email or password"
        end

        it { is_expected.to respond_with 422 }
      end

      context "password" do
        before(:each) do
          credentials = { email: @user.email, password: 'not_password' }
          post :create, { session: credentials }
        end

        it "should return an errors json with Invalid email or password" do
          expect(json_response[:errors]).to eql "Invalid email or password"
        end

        it { is_expected.to respond_with 422 }
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.token
    end

    it { should respond_with 204 }
  end
end
