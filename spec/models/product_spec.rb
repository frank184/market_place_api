require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "db" do
    context "columns" do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:price).of_type(:decimal) }
      it { is_expected.to have_db_column(:published).of_type(:boolean) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:line_items) }
    it { is_expected.to have_many(:orders).through(:line_items) }
  end

  describe "attributes" do
    subject { build(:product, title: 'title', price: 10.0) }
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

  describe "scopes" do
    before(:each) { @user = create :user }

    describe "#by_title" do
      before(:each) do
        @product1 = create :product, title: 'Plasma TV', user: @user
        @product2 = create :product, title: 'Fastest Laptop', user: @user
        @product3 = create :product, title: 'iPhone', user: @user
        @product4 = create :product, title: 'LCD TV', user: @user
      end

      context "when pattern = 'TV'" do
        before(:each) { @matches = Product.by_title 'TV' }

        it "should return 2 items" do
          expect(@matches).to have(2).items
        end

        it "should return the matching products" do
          expect(@matches).to match_array([@product1, @product4])
        end
      end
    end

    describe "#greater_than_or_equal_price" do
      before(:each) do
        @product1 = create :product, price: 5, user: @user
        @product2 = create :product, price: 10, user: @user
        @product3 = create :product, price: 15, user: @user
        @product4 = create :product, price: 20, user: @user
      end

      context "when pattern = 10" do
        before(:each) { @matches = Product.greater_than_or_equal_price 15 }

        it "should return 2 items" do
          expect(@matches).to have(2).items
        end

        it "should return the matching products" do
          expect(@matches).to match_array([@product3, @product4])
        end
      end
    end

    describe "#less_than_or_equal_price" do
      before(:each) do
        @product1 = create :product, price: 5, user: @user
        @product2 = create :product, price: 10, user: @user
        @product3 = create :product, price: 15, user: @user
        @product4 = create :product, price: 20, user: @user
      end

      context "when pattern = 10" do
        before(:each) { @matches = Product.less_than_or_equal_price 10 }

        it "should return 2 items" do
          expect(@matches).to have(2).items
        end

        it "should return the matching products" do
          expect(@matches).to match_array([@product1, @product2])
        end
      end
    end

    describe "#latest" do
      before(:each) do
        @product1 = create :product, user: @user
        @product2 = create :product, user: @user
        @product3 = create :product, user: @user
        @product4 = create :product, user: @user
        # Update products
        @product4.touch
        @product3.touch
        # Matches
        @matches = Product.latest
      end

      it "should return the latest products" do
        expect(@matches).to match_array([@product3, @product4, @product2, @product1])
      end
    end

    describe "#search" do
      before(:each) do
        @product1 = create :product, user: @user, price: 100, title: "Plasma tv"
        @product2 = create :product, user: @user, price: 50, title: "Videogame console"
        @product3 = create :product, user: @user, price: 150, title: "MP3"
        @product4 = create :product, user: @user, price: 99, title: "Laptop"
      end

      context "when title = 'Videogame' and min price = '100'" do
        it "returns an empty array" do
          expect(Product.search({ title: "videogame", min_price: 100 })).to be_empty
        end
      end

      context "when title = 'TV' and max price = '50'" do
        it "returns the product1" do
          expect(Product.search({ title: "TV", max_price: 150 })).to match_array([@product1])
        end
      end

      context "when an empty hash is sent" do
        it "returns all the products" do
          expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
        end
      end

      context "when product_ids is present" do
        it "returns the product from the ids" do
          expect(Product.search({ product_ids: [@product1.id, @product2.id] })).to match_array([@product1, @product2])
        end
      end
    end
  end

end
