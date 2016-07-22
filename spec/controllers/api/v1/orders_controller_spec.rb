require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:user) { create :user }

  before(:each) do
    include_default_accept_headers
    api_authorization_header user.token
  end

  describe "GET #index" do
    before(:each) do
      5.times { create :order, user: user, total: 10.0 }
      get :index, user_id: user.id
    end

    let(:orders_response) { json_response[:orders] }

    it "should return 5 user orders as JSON" do
      expect(orders_response).to have(5).items
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @order = create :order, user: user
      get :show, user_id: user.id, id: @order.id
    end

    let(:order_response) { json_response[:order] }

    it "should return the user's order as JSON" do
      expect(order_response[:id]).to eql @order.id
    end

    it "should have product_ids" do
      expect(order_response).to have_key :product_ids
    end

    it "should have empty product_ids" do
      expect(order_response[:product_ids]).to eql []
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when valid attributes" do
      let(:product1) { create :product, user: user }
      let(:product2) { create :product, user: user }
      let(:order_params) { {total: 10.0, product_ids: [product1.id, product2.id]} }
      before(:each) { post :create, {user_id: user.id, order: order_params} }

      let(:order_response) { json_response[:order] }

      it "should return the create order as JSON" do
        expect(order_response[:id]).to be_present
        expect(order_response[:user][:id]).to eql user.id
        expect(order_response[:total]).to eq order_params[:total]
        expect(order_response[:product_ids]).to match_array [product1.id, product2.id]
      end

      it { is_expected.to respond_with 201 }
    end

    context "when invalid attributes" do
      context "total is missing" do
        before(:each) { post :create, {user_id: user.id, order: {total: nil}} }
        let(:order_response) { json_response }

        it "should return an errors JSON" do
          expect(order_response).to have_key(:errors)
        end

        it "should explain what went wrong" do
          expect(order_response[:errors]).to include total: ["can't be blank", "is not a number"]
        end

        it { is_expected.to respond_with 422 }
      end

      context "total is negative" do
        before(:each) { post :create, {user_id: user.id, order: {total: -1}} }
        let(:order_response) { json_response }

        it "should return an errors JSON" do
          expect(order_response).to have_key(:errors)
        end

        it "should explain what went wrong" do
          expect(order_response[:errors]).to include total: ["must be greater than or equal to 0"]
        end

        it { is_expected.to respond_with 422 }
      end
    end
  end

end