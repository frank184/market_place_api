require "rails_helper"

RSpec.describe OrdersMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe "create" do
    before(:each) do
      @user = create :user
      @order = create :order, user: @user
      @order_mailer = OrdersMailer.create(@order)
    end

    it "should deliver to the order's user" do
      expect(@order_mailer).to deliver_to(@user.email)
    end

    it "should be sent from no-reply@marketplace.com" do
      expect(@order_mailer).to deliver_from('no-reply@marketplace.com')
    end

    it "should contain the order's number in message body" do
      expect(@order_mailer).to have_body_text(/Order: ##{@order.id}/)
    end

    it "should have the correct subject" do
      expect(@order_mailer).to have_subject(/Order Confirmation/)
    end

    it "should have the products count" do
      expect(@order_mailer).to have_body_text(/You ordered #{@order.products.count} products:/)
    end
  end

end
