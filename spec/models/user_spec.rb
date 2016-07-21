require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { @user = FactoryGirl.build(:user, email: 'user@mail.com', token: 'token') }
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
