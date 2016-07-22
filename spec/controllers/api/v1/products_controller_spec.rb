require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  before(:each) { include_default_accept_headers }

  describe "GET #index" do
    before(:each) { @n = 10 }

    context "when no product_ids param" do
      before(:each) do
        user = create :user
        @n.times { create :product, user: user }
        get :index
      end

      it "should return #{@n} products JSON" do
        products_response = json_response
        expect(products_response[:products]).to have(@n).items
      end

      it "should embed the user in each product" do
        products_response = json_response
        products_response[:products].each do |product|
          expect(product[:user]).to be_present
        end
      end

      it { is_expected.to respond_with 200 }
    end

    context "when product_ids params present" do
      before(:each) do
        @user = create :user
        @n.times { create :product, user: @user }
        get :index, product_ids: @user.product_ids
      end

      it "should return just the user's products" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end

      it { is_expected.to respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @product = create :product, user: create(:user)
      get :show, id: @product.id
    end

    it "should return a products JSON" do
      product_response = json_response
      expect(product_response[:product][:title]).to eql @product.title
    end

    it "should embed the user in the product" do
      product_response = json_response
      expect(product_response[:product])
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    before(:each) do
      @user = create(:user)
      api_authorization_header @user.token
    end
    context "when valid attributes" do
      before(:each) do
        @valid_attributes = attributes_for :product
        post :create, { user_id: @user.id, product: @valid_attributes }
      end

      it "should return the created product as JSON" do
        product_response = json_response
        expect(product_response[:product][:title]).to eql @valid_attributes[:title]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when invalid attributes" do
      before(:each) do
        @invalid_attributes = attributes_for :product, title: ""
        post :create, { user_id: @user.id, product: @invalid_attributes }
      end

      it "should return an errors JSON" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "should explain what went wrong" do
        product_response = json_response
        expect(product_response[:errors]).to include title: ["can't be blank"]
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = create :user
      @product = create :product, user: @user
      api_authorization_header @user.token
    end

    context "when updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: {title: "New Title"}}
      end

      it "should return the updated product as JSON" do
        product_response = json_response
        expect(product_response[:product][:title]).to eql "New Title"
      end

      it { is_expected.to respond_with 200 }
    end

    context "when not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: {title: ""}}
      end

      it "should return an errors JSON" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "should explain what went wrong" do
        product_response = json_response
        expect(product_response[:errors]).to include title: ["can't be blank"]
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = create :user
      api_authorization_header @user.token
      @product = create :product, user: @user
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { is_expected.to respond_with 204 }
  end

end
