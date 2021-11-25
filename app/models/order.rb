class Order < ApplicationRecord
  belongs_to :user
  has_many :carts, dependent: :destroy
  delegate :name, to: :user, prefix: true
  enum status: {
    open: Settings.open,
    confirmed: Settings.confirmed,
    shipping: Settings.shipping,
    completed: Settings.completed,
    cancelled: Settings.cancelled
  }
  scope :recent_orders, ->{order created_at: :desc}
end
