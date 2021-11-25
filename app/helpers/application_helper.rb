module ApplicationHelper
  def full_title page_title = ""
    base_title = t "food_drink"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def total_price order
    sum = 0
    order.carts.each do |cart|
      sum += cart.food_price * cart.quantity
    end
    number_to_currency(sum, locale: :vi)
  end
end
