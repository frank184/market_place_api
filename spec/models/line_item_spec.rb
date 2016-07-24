require 'rails_helper'

RSpec.describe LineItem, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:order_id) }
      it { is_expected.to have_db_column(:product_id) }
      it { is_expected.to have_db_column(:quantity) }
    end
  end

  describe "assocations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:order) }
    it { is_expected.to validate_presence_of(:product) }
  end

  describe "attributes" do
    let(:user) { create :user }
    let(:order) { create :order, user: user }
    let(:product) { create :product, user: user }
    subject { build :line_item, order: order, product: product, quantity: 5 }

    it { is_expected.to have_attributes(order: order) }
    it { is_expected.to have_attributes(order_id: order.id) }
    it { is_expected.to have_attributes(product: product) }
    it { is_expected.to have_attributes(product_id: product.id) }
    it { is_expected.to have_attributes(product_id: product.id) }
    it { is_expected.to have_attributes(quantity: 5) }
  end

  describe "callbacks" do
    describe "#after_create" do
      describe "#decrement_product_quantity!" do
        let(:user) { create :user }
        let(:product) { create :product, user: user, quantity: 1 }
        let(:line_item) { build :line_item, product: product, quantity: 1}
        it "should decrement products quantity" do
          expect{line_item.decrement_product_quantity!}.to change{product.quantity}.by(-line_item.quantity)
        end
      end
    end
  end

  describe "methods" do
    let(:user) { create :user }
    let(:product) { create :product, user: user, quantity: 1 }
    let(:line_item) { build :line_item, product: product, quantity: 1}
    before(:each) { line_item.decrement_product_quantity! }

    it "should decrement the product quantity" do
      expect(product.quantity).to eq 0
    end

    it "should save the product" do
      expect(product).to_not be_changed
    end
  end
end
