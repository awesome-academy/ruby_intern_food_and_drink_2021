class Food < ApplicationRecord
  belongs_to :category
  has_many :carts, dependent: :destroy
  scope :recent_foods, ->{order created_at: :desc}
end
