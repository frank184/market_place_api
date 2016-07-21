require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) { @product = build(:product, title: 'title', price: 10.0) }
  subject { @product }

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:price).of_type(:decimal) }
      it { is_expected.to have_db_column(:published).of_type(:boolean) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe "attributes" do
    it { is_expected.to have_attributes(title: 'title') }
    it { is_expected.to have_attributes(price: 10.0) }
    it { is_expected.to have_attributes(published: false) }
    it { is_expected.to have_attributes(user_id: nil) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
