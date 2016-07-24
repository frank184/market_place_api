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
  end

  describe "callbacks" do
    describe "before_validation" do
      before(:each) do

      end

      it "should call #generate_total" do

      end
    end
  end

  describe "methods" do
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
