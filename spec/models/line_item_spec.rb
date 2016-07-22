require 'rails_helper'

RSpec.describe LineItem, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:order_id) }
      it { is_expected.to have_db_column(:product_id) }
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
    subject { build :line_item, order: order, product: product }

    it { is_expected.to have_attributes(order: order) }
    it { is_expected.to have_attributes(product: product) }
  end
end
