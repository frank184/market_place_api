require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { @user = build(:user, email: 'user@mail.com', token: 'token') }
  subject { @user }

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:token).of_type(:string) }
    end
  end

  describe "attributes" do
    it { is_expected.to have_attributes(email: 'user@mail.com') }
    it { is_expected.to have_attributes(token: 'token') }
  end

  describe "associations" do
    context "#products" do
      it { is_expected.to have_many(:products) }

      context "on #destroy" do
        before(:each) do
          @user.save
          3.times { create :product, user: @user }
        end

        it "should remove associated products" do
          products = @user.products
          @user.destroy
          products.each {|product| expect{Product.find(product.id)}.to raise_error ActiveRecord::RecordNotFound}
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

  describe "#regenerate_token" do
    before(:each) { @user.regenerate_token }
    it { is_expected.to_not eql 'token' }
  end
end
