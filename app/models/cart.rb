class Cart < ApplicationRecord
  belongs_to :order
  belongs_to :food
  delegate :price, to: :food, prefix: true
end
