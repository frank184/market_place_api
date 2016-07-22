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
    subject { build :order, total: 10.0, user: user }

    it { is_expected.to have_attributes(total: 10.0) }
    it { is_expected.to have_attributes(user: user) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:total) }
    it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  end

end
