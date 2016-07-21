require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  before(:each) { include_default_accept_headers }

  describe "GET #index" do
    before(:each) do
      @n = 10
      user = create :user
      @n.times { create :product, user: user }
      get :index
    end

    it "should return #{@n} products JSON" do
      products_response = json_response
      expect(products_response[:products]).to have(@n).items
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @product = create :product, user: create(:user)
      get :show, id: @product.id
    end

    it "should return a products JSON" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { is_expected.to respond_with 200 }
  end

end
