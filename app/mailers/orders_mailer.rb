class OrdersMailer < ApplicationMailer
  
  def create(order)
    @order = order
    @user = @order.user
    mail to: @user.email, subject: 'Order Confirmation'
  end
end
