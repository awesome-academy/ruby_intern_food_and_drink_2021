class Order < ApplicationRecord
  belongs_to :user
  has_many :carts, dependent: :destroy
  has_many :foods, through: :order_details
  delegate :name, :email, to: :user, prefix: true
  enum status: {
    open: 0,
    confirmed: 1,
    shipping: 2,
    completed: 3,
    cancelled: 4
  }
  scope :recent_orders, ->{order created_at: :desc}
end
