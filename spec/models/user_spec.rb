require 'rails_helper'

RSpec.describe User, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:token).of_type(:string) }
    end
  end

  describe "associations" do
    context "#products" do
      it { is_expected.to have_many(:products) }
      context "on #destroy" do
        before(:each) do
          @user = create :user
          3.times {create :product, user: @user}
        end

        it "should remove associated products" do
          products = @user.products
          @user.destroy
          products.each {|product| expect{Product.find(product.id)}.to raise_error ActiveRecord::RecordNotFound}
        end
      end
    end

    context "#order" do
      it { is_expected.to have_many(:orders) }
      context "on #destroy" do
        before(:each) do
          @user = create :user
          3.times {create :order, user: @user}
        end

        it "should remove associated orders" do
          orders = @user.orders
          @user.destroy
          orders.each {|order| expect{Order.find(order.id)}.to raise_error ActiveRecord::RecordNotFound}
        end
      end
    end
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
    it { should validate_uniqueness_of(:token) }
  end

  describe "attributes" do
    subject { build(:user, email: 'user@mail.com', token: 'token') }

    it { is_expected.to have_attributes(email: 'user@mail.com') }
    it { is_expected.to have_attributes(token: 'token') }
  end

  describe "methods" do
    describe "#regenerate_token" do
      let(:user) { build :user, token: 'token' }
      before(:each) { user.regenerate_token }
      it { expect(@user.token).to_not eql 'token' }
    end
  end
end
