require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  before(:each) { include_default_accept_headers }
  let(:user) { create(:user) }


  describe "GET #index" do
    context "when no product_ids param" do
      let(:products_response) { json_response[:products] }
      let(:meta) { json_response[:meta] }

      before(:each) do
        5.times { create :product, user: user }
        get :index
      end

      it { expect(json_response).to have_key(:products) }

      it "should return 5 products JSON" do
        expect(products_response).to have(5).items
      end

      it "should embed the user in each product" do
        products_response.each { |product| expect(product[:user]).to be_present }
      end

      it { expect(json_response).to have_key(:meta) }
      it { expect(meta).to have_key(:pagination) }
      it { expect(meta[:pagination]).to have_key(:per_page) }
      it { expect(meta[:pagination]).to have_key(:total_pages) }
      it { expect(meta[:pagination]).to have_key(:total_objects) }

      it { is_expected.to respond_with 200 }
    end

    context "when product_ids params present" do
      before(:each) do
        5.times { create :product, user: user }
        get :index, product_ids: user.product_ids
      end

      let(:products_response) { json_response[:products] }

      it "should return just the user's products" do
        products_response.each { |product| expect(product[:user][:email]).to eql user.email }
      end

      it { is_expected.to respond_with 200 }
    end
  end

  describe "GET #show" do
    before(:each) do
      @product = create :product, user: user
      get :show, id: @product.id
    end

    let(:product_response) { json_response[:product] }

    it "should return a products JSON" do
      expect(product_response[:title]).to eql @product.title
    end

    it "should embed the user in the product" do
      expect(product_response[:user]).to be_present
    end

    it "should not reveal the user's token" do
      expect(product_response[:user][:token]).to be_falsey
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    before(:each) do
      api_authorization_header user.token
    end
    context "when valid attributes" do
      before(:each) do
        @valid_attributes = attributes_for :product
        post :create, { user_id: user.id, product: @valid_attributes }
      end

      let(:product_response) { json_response[:product] }

      it "should return the created product as JSON" do
        expect(product_response[:title]).to eql @valid_attributes[:title]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when invalid attributes" do
      before(:each) do
        @invalid_attributes = attributes_for :product, title: ""
        post :create, { user_id: user.id, product: @invalid_attributes }
      end

      let(:product_response) { product_response = json_response }

      it "should return an errors JSON" do
        expect(product_response).to have_key(:errors)
      end

      it "should explain what went wrong" do
        expect(product_response[:errors]).to include title: ["can't be blank"]
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @product = create :product, user: user
      api_authorization_header user.token
    end

    context "when updated" do
      before(:each) { patch :update, {user_id: user.id, id: @product.id, product: {title: 'New Title'}} }
      let(:product_response) { json_response[:product] }

      it "should return the updated product as JSON" do
        expect(product_response[:title]).to eql 'New Title'
      end

      it { is_expected.to respond_with 200 }
    end

    context "when not updated" do
      before(:each) { patch :update, {user_id: user.id, id: @product.id, product: {title: ""}} }
      let(:product_response) { json_response }

      it "should return an errors JSON" do
        expect(product_response).to have_key(:errors)
      end

      it "should explain what went wrong" do
        expect(product_response[:errors]).to include title: ["can't be blank"]
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      api_authorization_header user.token
      @product = create :product, user: user
      delete :destroy, { user_id: user.id, id: @product.id }
    end

    it { is_expected.to respond_with 204 }
  end

end
