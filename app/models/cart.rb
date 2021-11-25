class Cart < ApplicationRecord
  belongs_to :order
  belongs_to :food
  delegate :name, to: :food, prefix: true
  delegate :price, to: :food, prefix: true
end
