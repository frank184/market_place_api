require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:user) { create :user }

  before(:each) do
    include_default_accept_headers
    api_authorization_header user.token
  end

  describe "GET #index" do
    before(:each) do
      5.times { create :order, user: user }
      get :index, user_id: user.id
    end

    let(:orders_response) { json_response[:orders] }

    it "should return 5 user orders as JSON" do
      expect(orders_response).to have(5).items
    end

    it "should return 5 totals of 0.0 because of no products" do
      orders_response.each {|order| expect(order[:total].to_f).to eq 0.0}
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @product = create :product, price: 10.0, user: user
      @order = create :order, user: user, product_ids: [@product.id]
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
      expect(order_response[:product_ids]).to eql [@product.id]
    end

    it "should include the order's total" do
      expect(order_response[:total].to_f).to eq @product.price
    end

    it "should include order's products" do
      expect(order_response).to have_key(:products)
    end

    it "should have one product in products" do
      expect(order_response[:products]).to have(1).items
    end

    it "should have the correct order products" do
      order_response[:products].each {|product| expect(product[:id]).to eq @product.id}
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when valid attributes" do
      let(:product1) { create :product, user: user, price: 10.0, quantity: 10 }
      let(:product2) { create :product, user: user, price: 10.0, quantity: 10 }
      let(:order_params) { {product_ids_quantities: [[product1.id, 2], [product2.id, 3]]} }
      before(:each) { post :create, {user_id: user.id, order: order_params} }

      let(:order_response) { json_response[:order] }

      it "should return the create order as JSON" do
        expect(order_response[:id]).to be_present
        expect(order_response[:user][:id]).to eql user.id
        expect(order_response[:total].to_f).to eq (product1.price + product2.price)
        expect(order_response[:product_ids]).to match_array [product1.id, product2.id]
        expect(product1.reload.quantity).to eq 8
        expect(product2.reload.quantity).to eq 7
      end

      it { is_expected.to respond_with 201 }
    end

    # Invalid since we're setting the user and total ourselves
    #
    # context "when invalid attributes" do
    #   context "total is missing" do
    #     before(:each) { post :create, {user_id: user.id, order: {total: nil}} }
    #     let(:order_response) { json_response }
    #
    #     it "should return an errors JSON" do
    #       expect(order_response).to have_key(:errors)
    #     end
    #
    #     it "should explain what went wrong" do
    #       expect(order_response[:errors]).to include user: ["can't be blank"]
    #     end
    #
    #     it { is_expected.to respond_with 422 }
    #   end
    #
    #   context "total is negative" do
    #     before(:each) { post :create, {user_id: user.id, order: {total: -1}} }
    #     let(:order_response) { json_response }
    #
    #     it "should return an errors JSON" do
    #       expect(order_response).to have_key(:errors)
    #     end
    #
    #     it "should explain what went wrong" do
    #       expect(order_response[:errors]).to include total: ["must be greater than or equal to 0"]
    #     end
    #
    #     it { is_expected.to respond_with 422 }
    #   end
    # end
  end

end
