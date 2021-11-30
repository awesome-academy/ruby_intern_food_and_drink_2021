class Food < ApplicationRecord
  belongs_to :category
  has_many :carts, dependent: :destroy
  has_many :orders, through: :order_details
  scope :recent_foods, ->{order created_at: :desc}
  delegate :category_name, to: :category
end
