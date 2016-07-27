require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:total).of_type(:decimal) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items) }
    it { is_expected.to have_many(:products).through(:line_items) }
  end

  describe "attributes" do
    let(:user) { create :user }
    subject { build :order, user: user, total: 10 }

    it { is_expected.to have_attributes(total: 10.0) }
    it { is_expected.to have_attributes(user: user) }
    it { is_expected.to have_attributes(user_id: user.id) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:user) }
    # it { is_expected.to validate_presence_of(:total) }
    # it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
    describe "custom validation" do
      context "enough products" do
        let(:user) { create :user }
        let(:order) { build :order, user: user }

        context "when unsufficient products in stock" do
          let(:product1) { create :product, title: 'TV', user: user, price: 100, quantity: 5 }
          let(:product2) { create :product, title: 'Gameboy', user: user, price: 85, quantity: 10 }
          before(:each) do
            order.product_ids_quantities = [[product1.id, 10], [product2.id, 15]]
            order.save
          end

          it "should be invalid" do
            expect(order).to_not be_valid
          end

          it "should have an error on tv and gamboy" do
            expect(order).to have(1).errors_on(:tv)
            expect(order).to have(1).errors_on(:gameboy)
          end

          it "should explain why these are invalid" do
            expect(order.errors[:tv]).to include "is out of stock, only 5 left in stock"
            expect(order.errors[:gameboy]).to include "is out of stock, only 10 left in stock"
          end
        end

        context "when no products left" do
          let(:product1) { create :product, title: 'TV', user: user, price: 100, quantity: 0 }
          let(:product2) { create :product, title: 'Gameboy', user: user, price: 85, quantity: 0 }
          before(:each) do
            order.product_ids_quantities = [[product1.id, 10], [product2.id, 15]]
            order.save
          end

          it "should be invalid" do
            expect(order).to_not be_valid
          end

          it "should have an error on tv and gamboy" do
            expect(order).to have(1).errors_on(:tv)
            expect(order).to have(1).errors_on(:gameboy)
          end

          it "should explain why it is invalid" do
            expect(order.errors[:tv]).to include "is out of stock, none left in stock"
            expect(order.errors[:gameboy]).to include "is out of stock, none left in stock"
          end
        end
      end
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      describe "#generate_total" do
        let(:user) { create :user }
        let(:product1) { create :product, price: 10.0, user: user }
        let(:product2) { create :product, price: 10.0, user: user }
        before(:each) { @order = create :order, user: user, product_ids: [product1.id, product2.id] }

        it "should generate the order's total from products" do
          expect(@order.total).to eq 20.0
        end
      end
    end
  end

  describe "methods" do
    describe "#generate_total" do
      let(:user) { create :user }
      let(:product1) { create :product, user: user, price: 10.0 }
      let(:product2) { create :product, user: user, price: 10.0 }
      before(:each) do
        @order = build :order, user: user, product_ids: [product1.id, product2.id]
        @order.generate_total
      end

      it "should sum the products and set the total" do
        expect(@order.total).to eq 20
      end
    end

    describe "#product_ids_quantities=" do
      let(:user) { create :user }
      let(:product1) { create :product, user: user, price: 10.0 }
      let(:product2) { create :product, user: user, price: 10.0 }
      before(:each) { @order = build :order, user: user }

      it "should build 2 line_items for the order" do
        expect{@order.product_ids_quantities = [[product1.id, 2], [product2.id, 3]]}.to change{@order.line_items.size}.from(0).to(2)
      end
    end

    describe "#product_ids_quantities" do
      let(:user) { create :user }
      let(:product1) { create :product, user: user, price: 10.0 }
      let(:product2) { create :product, user: user, price: 10.0 }
      before(:each) do
        @order = build :order, user: user
        @order.product_ids_quantities = [[product1.id, 2], [product2.id, 3]]
        @match = @order.product_ids_quantities
      end

      it "should have matching line_items" do
        expect(@match).to match_array [[product1.id, 2], [product2.id, 3]]
      end
    end
  end

end
