class UserMailer < ApplicationMailer
  def order_status order, carts, total
    @order = order
    @carts = carts
    @total = total
    mail to: @order.user_email, subject: t("title_#{@order.status}")
  end
end
