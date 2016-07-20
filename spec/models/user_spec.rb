require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user, email: 'user@mail.com') }
  subject { @user }

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:email).of_type(:string) }
    end
  end

  describe "attributes" do
    it { is_expected.to have_attributes(email: 'user@mail.com') }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
  end
end
